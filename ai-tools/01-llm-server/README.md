# 멀티 모델 & sLLM Docker 서빙 플레이그라운드

> **실습 환경**: Windows 11 WSL2 / Docker Desktop 4.73.1 / RTX 3080 (8GB VRAM) / CUDA 12.9
> Ollama Docker로 LLM을 GPU 서빙하고, Open WebUI로 브라우저 채팅 환경을 구성합니다.

---

## 1) 파일 구성

| 파일 | 설명 |
|---|---|
| `docker-compose.ollama.yml` | Ollama 단독 (CPU 전용, 포트 11435) |
| `docker-compose.ollama-gpu.yml` | Ollama 단독 (NVIDIA GPU, 포트 11435) |
| `docker-compose.stack.yml` | Ollama GPU + Open WebUI 풀 스택 |

> 포트 `11435`를 사용합니다 (기본 11434 대비 충돌 방지).

---

## 2) 빠른 시작

### A. CPU 전용

```bash
cd ai-tools/28-Multi-Model-sLLM-Serving

docker compose -f docker-compose.ollama.yml up -d
curl http://localhost:11435/
```

### B. NVIDIA GPU (RTX 3080 / WSL2)

> Docker Desktop 4.73.1+ 은 별도 nvidia-container-toolkit 설치 없이 GPU 지원

```bash
docker compose -f docker-compose.ollama-gpu.yml up -d

# GPU 사용 확인
docker exec ollama nvidia-smi
```

### C. Ollama GPU + Open WebUI 풀 스택

```bash
docker compose -f docker-compose.stack.yml up -d
# UI: http://localhost:3000  (최초 접속 시 관리자 계정 생성)
# API: http://localhost:11435
```

---

## 3) 설치된 모델 (현재 환경 기준)

```bash
# 설치된 모델 확인
docker exec ollama ollama list
```

| 모델 | 크기 | 용도 | VRAM 요구 |
|---|---|---|---|
| `qwen3.5:latest` | 6.6 GB | 범용/한국어 | 8 GB |
| `llama3:latest` | 4.7 GB | 범용 대화 | 6 GB |
| `nomic-embed-text:latest` | 274 MB | 임베딩 (RAG 필수) | CPU 가능 |
| `qwen2.5-coder:1.5b-base` | 986 MB | 코드 생성 | CPU 가능 |
| `ko-llama:latest` | 1.3 GB | 한국어 특화 | CPU 가능 |
| `llava:34b` | 20 GB | 멀티모달 (이미지+텍스트) | 24 GB+ |

### RTX 3080 (8GB) 권장 모델 조합

```bash
# 범용 대화 (GPU 완전 오프로드 가능)
docker exec ollama ollama pull qwen3.5:latest    # 6.6GB → VRAM 내 처리

# 임베딩 (RAG 파이프라인 필수)
docker exec ollama ollama pull nomic-embed-text  # 274MB

# 코딩 어시스턴트
docker exec ollama ollama pull qwen2.5-coder:1.5b-base

# 추가 권장 — 한국어 강점
docker exec ollama ollama pull qwen2.5:7b        # 4.7GB
```

---

## 4) 추론 테스트

### REST API (포트 11435)

```bash
# 단일 응답
curl -s http://localhost:11435/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen3.5:latest",
    "prompt": "Docker와 가상머신의 차이를 3줄로 설명해줘.",
    "stream": false
  }' | python3 -m json.tool

# 임베딩 생성 (RAG 파이프라인용)
curl -s http://localhost:11435/api/embeddings \
  -H "Content-Type: application/json" \
  -d '{
    "model": "nomic-embed-text",
    "prompt": "Docker 컨테이너는 격리된 프로세스입니다."
  }' | python3 -m json.tool

# 채팅 형식
curl -s http://localhost:11435/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen3.5:latest",
    "messages": [{"role": "user", "content": "Qdrant와 pgvector의 차이는?"}],
    "stream": false
  }' | python3 -m json.tool
```

### CLI 대화

```bash
docker exec -it ollama ollama run qwen3.5:latest
```

---

## 5) 모델별 자원 요구

| 모델 크기 | RAM(CPU) | VRAM(GPU) | RTX 3080 가용 여부 |
|---|---|---|---|
| 1~2B | 4 GB | 2 GB | ✅ 완전 GPU |
| 3~4B | 8 GB | 4 GB | ✅ 완전 GPU |
| 7~8B | 12 GB | 6~8 GB | ✅ 완전 GPU |
| 13~14B | 20 GB | 12~14 GB | ⚠️ 일부 CPU 오프로드 |
| 34B+ | 40 GB+ | 20 GB+ | ❌ CPU 전용 서빙 |

> RTX 3080 8GB VRAM 기준 — 7~8B 모델까지 완전 GPU 처리 가능.
> llava:34b (20GB)는 CPU 메모리 서빙 (응답 느림).

---

## 6) 정리

```bash
# 특정 모델 삭제
docker exec ollama ollama rm llava:34b

# 컨테이너 + 볼륨 전체 정리
docker compose -f docker-compose.stack.yml down -v
```

---

## 7) 체크리스트

- [ ] `docker-compose.ollama-gpu.yml` 기동 후 `docker exec ollama nvidia-smi` 로 GPU 확인
- [ ] `ollama list` 로 설치된 모델 확인
- [ ] `/api/generate` REST API 로 추론 응답 확인
- [ ] `/api/embeddings` 로 임베딩 벡터 생성 확인
- [ ] Open WebUI(`http://localhost:3000`) 접속 및 멀티 모델 채팅 확인
