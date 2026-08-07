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
docker compose up --build
```

서비스는 백엔드 `http://localhost:8000`, 프런트엔드 `http://localhost:8080`에서 확인할 수 있습니다.

## Tesseract OCR 예제

`tesseract/README.md`에서 입력 이미지와 한국어·영어 학습 데이터를 사용하는 OCR 실행 방법을 확인하세요.
