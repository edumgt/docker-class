# Open WebUI — 브라우저 기반 멀티 모델 채팅 UI

> Ollama에 연결된 브라우저 UI입니다. 01-llm-server가 먼저 기동되어 있어야 합니다.

---

## 파일 구성

| 파일 | 설명 |
|---|---|
| `docker-compose.yml` | Ollama (GPU) + Open WebUI 풀 스택 |

---

## 빠른 시작

```bash
cd ai-tools/03-webui

docker compose up -d

# UI: http://localhost:3000
# Ollama API: http://localhost:11435
```

최초 접속 시 관리자 계정을 생성합니다.

---

## Open WebUI 설정

1. http://localhost:3000 접속 → 계정 생성
2. Settings → Connections → Ollama URL: `http://ollama:11434`
3. Settings → Documents → Vector DB: `Qdrant`, URL: `http://qdrant:6333`
4. 모델 선택 → 채팅 시작

---

## 이미 Ollama가 실행 중인 경우

Ollama 컨테이너(`docker compose -f ../01-llm-server/docker-compose.gpu.yml up -d`)가 이미 실행 중이면 WebUI만 따로 기동할 수 있습니다:

```bash
docker run -d \
  --name open-webui \
  --network shared-net \
  -p 3000:8080 \
  -e OLLAMA_BASE_URL=http://ollama:11434 \
  -v open-webui-data:/app/backend/data \
  --restart unless-stopped \
  ghcr.io/open-webui/open-webui:main
```
