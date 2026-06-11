FROM python:3.11-slim

WORKDIR /app

# intentionally simple demo image for Trivy scanning practice
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
