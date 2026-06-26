# 통합 AI RAG 스택

> Ollama (GPU) + Qdrant + Open WebUI를 단일 Compose로 기동하는 통합 실습입니다.
> 임베딩 생성 → 벡터 저장 → 유사 검색 → LLM 답변의 전체 RAG 파이프라인을 구성합니다.

---

## 1) 아키텍처

```
[사용자 질문]
     │
     ▼
[Open WebUI :3000]  ←─── 브라우저 채팅 UI
     │  │
     │  └─── Qdrant RAG 검색 (:6333)
     │             │
     │             └─── 임베딩 벡터 저장소
     │
     └──── Ollama LLM (:11435)
                │
                ├── qwen3.5       : 범용 대화
                ├── nomic-embed-text : 임베딩 생성
                └── qwen2.5-coder : 코드 생성
```

---

## 2) 빠른 시작

```bash
# 공유 네트워크 확인 (없으면 생성)
docker network create shared-net 2>/dev/null || true

cd ai-tools/29-AI-RAG-Stack
docker compose up -d

# 상태 확인
docker compose ps
```

접속:
- **Open WebUI**: http://localhost:3000 (최초 접속 시 관리자 계정 생성)
- **Ollama API**: http://localhost:11435
- **Qdrant 대시보드**: http://localhost:6333/dashboard

---

## 3) 초기 모델 설정

스택 기동 후 필수 모델을 설치합니다:

```bash
# 임베딩 모델 (RAG 필수)
docker exec ollama ollama pull nomic-embed-text

# 범용 대화 모델
docker exec ollama ollama pull qwen3.5:latest

# 설치 확인
docker exec ollama ollama list
```

---

## 4) RAG 파이프라인 검증

### 임베딩 생성 테스트

```bash
curl -s http://localhost:11435/api/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model":"nomic-embed-text","prompt":"Docker 컨테이너는 격리된 프로세스입니다."}' \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'벡터 차원: {len(d[\"embedding\"])}')"
# 출력: 벡터 차원: 768
```

### Qdrant 컬렉션 생성 + 벡터 삽입

```bash
# 컬렉션 생성 (nomic-embed-text 차원 768)
curl -s -X PUT http://localhost:6333/collections/docs \
  -H "Content-Type: application/json" \
  -d '{"vectors":{"size":768,"distance":"Cosine"}}'

# 벡터 삽입 (Python 예시)
python3 - <<'EOF'
import requests, json

OLLAMA = "http://localhost:11435"
QDRANT = "http://localhost:6333"
COLLECTION = "docs"

texts = [
    "Docker는 컨테이너 기반 가상화 플랫폼입니다.",
    "Qdrant는 벡터 유사도 검색을 지원하는 데이터베이스입니다.",
    "Ollama는 오픈소스 LLM을 로컬에서 서빙합니다.",
]

points = []
for i, text in enumerate(texts):
    r = requests.post(f"{OLLAMA}/api/embeddings",
                      json={"model": "nomic-embed-text", "prompt": text})
    vec = r.json()["embedding"]
    points.append({"id": i+1, "vector": vec, "payload": {"text": text}})

requests.put(f"{QDRANT}/collections/{COLLECTION}/points",
             json={"points": points})
print(f"삽입 완료: {len(points)}개 벡터")
EOF
```

### 유사도 검색

```bash
python3 - <<'EOF'
import requests

OLLAMA = "http://localhost:11435"
QDRANT = "http://localhost:6333"
QUERY = "컨테이너 가상화란?"

# 질의 임베딩
r = requests.post(f"{OLLAMA}/api/embeddings",
                  json={"model": "nomic-embed-text", "prompt": QUERY})
query_vec = r.json()["embedding"]

# Qdrant 검색
r = requests.post(f"{QDRANT}/collections/docs/points/search",
                  json={"vector": query_vec, "limit": 2})
results = r.json()["result"]
for hit in results:
    print(f"[{hit['score']:.3f}] {hit['payload']['text']}")
EOF
```

---

## 5) Open WebUI에서 Qdrant RAG 사용

1. http://localhost:3000 접속 → 관리자 로그인
2. Settings → Documents → Vector DB: `Qdrant`
3. URL: `http://qdrant:6333`
4. 문서 업로드 → 채팅창에서 `#` 으로 컬렉션 참조

---

## 6) 종료 및 정리

```bash
# 컨테이너 종료 (데이터 유지)
docker compose down

# 컨테이너 + 볼륨 전체 삭제
docker compose down -v
```
