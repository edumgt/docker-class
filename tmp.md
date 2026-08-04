## 명령어
```bash
docker run --rm --user "$(id -u):$(id -g)" \
  -v /home/ubuntu/docker-class:/data \
  -v /home/ubuntu/docker-class/tessdata:/usr/local/share/tessdata \
  jitesoft/tesseract-ocr:latest \
  /data/1.png /data/output -l kor+eng
```

---

## 보는법
```bash
cat /home/ubuntu/docker-class/output.txt
```