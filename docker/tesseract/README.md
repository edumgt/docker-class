## 명령어
```bash
cd docker/tesseract
docker run --rm --user "$(id -u):$(id -g)" \
  -v "$PWD":/data \
  -v "$PWD/tessdata":/usr/local/share/tessdata \
  jitesoft/tesseract-ocr:latest \
  /data/1.png /data/output -l kor+eng
```

---

## 보는법
```bash
cat output.txt
```