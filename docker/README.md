# Docker 실행 리소스

루트에 흩어져 있던 Docker 실행 예제와 보조 파일을 모아 둔 폴더입니다. 각 예제는 이 디렉터리를 기준으로 실행합니다.

## 구성

| 경로 | 내용 |
|---|---|
| `docker-compose.yml` | FastAPI 백엔드와 Nginx 프런트엔드를 함께 실행하는 Compose 예제 |
| `Dockerfile` | Python/FastAPI 백엔드 이미지 예제 |
| `Dockerfile.fe` | `frontend/` 정적 파일을 제공하는 Nginx 이미지 예제 |
| `Dockerfile.crawler` | Scrapy 크롤링 환경 이미지 예제 |
| `Dockerfile.play` | Playwright Python 실행 환경 이미지 예제 |
| `requirements.txt` | Python/Playwright 예제에서 사용하는 의존성 목록 |
| `frontend/` | Nginx로 제공할 정적 프런트엔드 예제 |
| `tesseract/` | Tesseract OCR 실행 예제, 학습 데이터, 입력 및 결과 파일 |

## 실행

```bash
cd docker
docker network create shared-net 2>/dev/null || true
docker compose build backend frontend capture-runner ocr-runner
docker compose up backend frontend
```

서비스는 백엔드 `http://localhost:8000`, 프런트엔드 `http://localhost:8080`에서 확인할 수 있습니다.

## 웹 캡처 · OCR 앱

프런트엔드에서 URL을 제출하면 백엔드가 다음 두 컨테이너를 순서대로 실행합니다.

1. `local/capture-runner:latest` — Playwright로 스크린샷과 렌더링 텍스트 생성
2. `local/ocr-runner:latest` — Tesseract(`kor+eng`)로 스크린샷 OCR

초기 실행에서는 도구 이미지까지 빌드한 후 API와 프런트엔드를 시작합니다.

```bash
cd docker
docker network create shared-net 2>/dev/null || true
docker compose build backend frontend capture-runner ocr-runner
docker compose up backend frontend
```

브라우저에서 `http://localhost:8080`을 열어 URL을 입력합니다. 이미 사용 중인 경우 `FRONTEND_PORT=8081 docker compose up frontend`처럼 포트를 바꿀 수 있습니다. 결과는 `capture-results` Docker 볼륨에 작업 ID별로 보관되며, 백엔드의 `/results/<job-id>/` 경로로 제공됩니다.

## Tesseract OCR 예제

`tesseract/README.md`에서 입력 이미지와 한국어·영어 학습 데이터를 사용하는 OCR 실행 방법을 확인하세요.
