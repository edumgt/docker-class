# AI Tools — Docker 기반 AI 환경 구축 가이드

> **실습 환경**: Windows 11 WSL2 / Docker Desktop 4.73.1 / RTX 3080 8GB / CUDA 12.9 / RAM 19GB
>
> AI 업무 처리에 필요한 Docker 인프라를 **설치 순서대로** 구성합니다.
> 각 단계는 독립 실행 가능하며, 순서대로 완료하면 완전한 로컬 RAG 파이프라인이 완성됩니다.

---

## 폴더 구조

```
ai-tools/
├── README.md               ← 이 파일 (단계별 마스터 가이드)
├── 01-llm-server/          ← Step 1: Ollama LLM 서버 (GPU)
├── 02-vector-db/           ← Step 2: Vector DB (Qdrant / pgvector / Chroma / Weaviate)
├── 03-webui/               ← Step 3: Open WebUI (브라우저 채팅 UI)
└── 04-rag-stack/           ← Step 4: 통합 RAG 스택 (Ollama + Qdrant + WebUI)
```

---

## Step 0 — 사전 준비

### 0-1. 환경 확인

```bash
docker version                              # Engine 29.4+, Desktop 4.73+
nvidia-smi                                  # RTX 3080, CUDA 12.9
docker info | grep -E "CPUs|Memory"         # CPU 16코어, RAM 19GB
```

### 0-2. 공유 네트워크 생성 (한 번만)

```bash
docker network create shared-net 2>/dev/null || echo "already exists"
```

### 0-3. 현재 상태 점검

```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

---

## Step 1 — LLM 서버 (Ollama GPU)

📁 [`01-llm-server/`](./01-llm-server/)

RTX 3080으로 LLM을 서빙합니다. 추론 API + 임베딩 API를 제공합니다.

```bash
cd ai-tools/01-llm-server

# GPU 서빙 시작
docker compose -f docker-compose.gpu.yml up -d

# GPU 사용 확인
docker exec ollama nvidia-smi

# API 헬스체크 (포트 11435)
curl http://localhost:11435/
```

### 핵심 모델 설치 (RTX 3080 8GB 기준)

```bash
# 범용 대화 (6.6GB — VRAM 완전 처리 가능)
docker exec ollama ollama pull qwen3.5:latest

# 임베딩 — RAG 파이프라인 필수 (274MB)
docker exec ollama ollama pull nomic-embed-text

# 코드 어시스턴트 (986MB — CPU 가능)
docker exec ollama ollama pull qwen2.5-coder:1.5b-base

# 설치 확인
docker exec ollama ollama list
```

**포트**: `11435` (내부 11434 → 외부 11435)

---

## Step 2 — Vector DB (Qdrant 권장)

📁 [`02-vector-db/`](./02-vector-db/)

임베딩 벡터를 저장하고 유사도 검색을 수행합니다.

```bash
cd ai-tools/02-vector-db

# Qdrant 기동 (권장)
docker compose -f docker-compose.qdrant.yml up -d

# 헬스체크
curl http://localhost:6333/healthz

# 대시보드
open http://localhost:6333/dashboard
```

### 선택: 다른 Vector DB

```bash
# pgvector — PostgreSQL 기반, SQL + 벡터 검색
docker compose -f docker-compose.pgvector.yml up -d

# Chroma — Python 친화적
docker compose -f docker-compose.chroma.yml up -d

# Weaviate — GraphQL + 벡터 검색
docker compose -f docker-compose.weaviate.yml up -d
```

**포트**: Qdrant `6333`(REST) / `6334`(gRPC)

---

## Step 3 — Open WebUI (브라우저 채팅 UI)

📁 [`03-webui/`](./03-webui/)

Ollama에 연결된 브라우저 기반 멀티 모델 채팅 환경입니다.

```bash
cd ai-tools/03-webui

docker compose up -d

# UI: http://localhost:3000
```

설정:
1. 최초 접속 → 관리자 계정 생성
2. Settings → Connections → Ollama URL: `http://ollama:11434`
3. Settings → Documents → Vector DB: `Qdrant`, URL: `http://qdrant:6333`

**포트**: `3000`

---

## Step 4 — 통합 RAG 스택

📁 [`04-rag-stack/`](./04-rag-stack/)

Ollama + Qdrant + Open WebUI를 단일 Compose로 한 번에 기동합니다.
Step 1~3을 개별 실행하는 대신 이 하나로 전체 AI 환경을 구성할 수 있습니다.

```bash
cd ai-tools/04-rag-stack

docker compose up -d

# 접속
# Open WebUI : http://localhost:3000
# Ollama API : http://localhost:11435
# Qdrant API : http://localhost:6333
```

### RAG 파이프라인 검증

```bash
# 1. 임베딩 생성 테스트
curl -s http://localhost:11435/api/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model":"nomic-embed-text","prompt":"Docker 컨테이너는 격리된 프로세스입니다."}' \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'벡터 차원: {len(d[\"embedding\"])}')"

# 2. Qdrant 컬렉션 생성
curl -s -X PUT http://localhost:6333/collections/docs \
  -H "Content-Type: application/json" \
  -d '{"vectors":{"size":768,"distance":"Cosine"}}'
```

---

## 포트 요약

| 단계 | 서비스 | 포트 | 설명 |
|---|---|---|---|
| Step 1 | Ollama API | `11435` | LLM 추론 + 임베딩 (`/api/generate`, `/api/embeddings`) |
| Step 2 | Qdrant REST | `6333` | Vector DB API + 대시보드 |
| Step 2 | Qdrant gRPC | `6334` | Vector DB gRPC |
| Step 2 | pgvector | `5432` | PostgreSQL + 벡터 확장 |
| Step 3 | Open WebUI | `3000` | 브라우저 채팅 UI |

---

## 트러블슈팅

### Ollama가 GPU를 사용하지 않을 때

```bash
docker exec ollama ollama ps
# VRAM 초과 시 자동 CPU 오프로드 → 더 작은 모델 사용
```

### Qdrant 연결 실패

```bash
docker logs qdrant --tail 20
curl http://localhost:6333/healthz
```

### 포트 충돌

```bash
ss -tlnp | grep -E "11435|6333|3000"
docker ps --filter publish=11435
```

### GPU가 안 보일 때

```bash
docker desktop restart   # Docker Desktop 재시작
docker run --rm --gpus all nvidia/cuda:12.9.0-base-ubuntu22.04 nvidia-smi
```
