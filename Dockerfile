# 베이스 이미지 선택 (Python 3.10 예시)
FROM python:3.10-slim

# 작업 디렉토리 설정
WORKDIR /app

# requirements.txt 복사 및 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 소스 코드 복사
COPY . .

# 컨테이너가 실행할 명령어 (예: uvicorn으로 FastAPI 실행)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
