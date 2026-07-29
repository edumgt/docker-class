# AI 응용 개발 컨테이너

Ollama, Qdrant 같은 인프라는 별도 컨테이너로 두고, 이 컨테이너에서 Python 기반 AI 응용 프로그램을 개발합니다. 호스트에 Python 패키지를 흩어 설치하지 않아도 되어 수업 PC와 개인 PC에서 같은 실행 환경을 재현할 수 있습니다.

## 포함된 오픈소스

| 영역 | 패키지 | 사용 목적 |
|---|---|---|
| API | FastAPI, Uvicorn, Pydantic Settings | HTTP API, 개발 서버, 환경변수 설정 |
| RAG / Agent | LangChain, LangGraph, LlamaIndex | RAG 체인, 에이전트 흐름, 문서 인덱싱 |
| LLM / 임베딩 | Ollama, Transformers, Sentence Transformers | 로컬 모델 호출과 임베딩 실험 |
| Vector DB | Qdrant Client, ChromaDB, pgvector | 벡터 검색 구현 및 DB 선택 실험 |
| 데이터 | SQLAlchemy, Psycopg | PostgreSQL/pgvector 접근 |
| 개발 경험 | JupyterLab, Pytest, Ruff, Debugpy | 탐색, 테스트, 품질 검사, 디버깅 |

`requirements.txt`는 호환되는 메이저 버전 범위를 지정합니다. 수업 시점의 완전한 재현성이 필요하면 첫 정상 빌드 이후 `pip freeze` 결과를 별도 lock 파일로 보관하세요.

## 실행

전제 조건은 Docker Desktop/Engine, 외부 네트워크 `shared-net`, 그리고 선택적으로 Ollama·Qdrant입니다.

```bash
# 저장소 루트에서 한 번만 실행
docker network create shared-net 2>/dev/null || true

# Step 4의 AI 인프라를 먼저 실행하는 경우
cd ../04-rag-stack && docker compose up -d

# 개발 컨테이너 시작
cd ../05-ai-dev-container
cp .env.example .env
# .env에서 JUPYTER_TOKEN을 긴 임의 값으로 바꾼 뒤
docker compose up --build -d
```

| 주소 | 역할 |
|---|---|
| `http://localhost:8000/docs` | FastAPI 자동 API 문서 |
| `http://localhost:8000/health` | 개발 컨테이너 설정 확인 |
| `http://localhost:8000/models` | Ollama 모델 목록 연결 테스트 |
| `http://localhost:8888/lab?token=<JUPYTER_TOKEN>` | JupyterLab |

## 개발 흐름

```bash
# 컨테이너 셸
docker compose exec ai-dev bash

# 테스트 및 정적 검사
pytest -q
ruff check app tests

# 이미지 재빌드가 필요한 경우 (requirements.txt 또는 Dockerfile 변경 후)
docker compose up --build -d
```

`app/`, `tests/`, `workspace/`는 bind mount되어 저장하면 즉시 호스트에도 반영됩니다. Uvicorn은 `app/` 변경을 감지해 자동 재시작합니다. 노트북과 학습 데이터는 `workspace/`에 보관합니다.

## 서비스 주소 원칙

같은 Docker 네트워크의 컨테이너에서는 포트 공개 주소가 아니라 서비스 이름을 사용합니다.

| 호출 위치 | Ollama | Qdrant |
|---|---|---|
| 개발 컨테이너 | `http://ollama:11434` | `http://qdrant:6333` |
| Windows/WSL 호스트 | `http://localhost:11435` | `http://localhost:6333` |

AI 인프라를 아직 실행하지 않았다면 `/health`와 테스트는 동작하지만 `/models`는 연결 오류를 반환합니다. 먼저 `ai-tools/04-rag-stack`을 기동하거나 필요한 서비스를 같은 `shared-net`에 연결하세요.
