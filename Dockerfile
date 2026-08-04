FROM jbarlow83/ocrmypdf

USER root
RUN apt-get update && apt-get install -y \
    tesseract-ocr-kor \
    && rm -rf /var/lib/apt/lists/*
