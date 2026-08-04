docker run --rm -v /home/ubuntu/docker-class:/data jitesoft/tesseract-ocr:latest \
  tesseract /data/1.png /data/output -l kor+eng
cat /home/ubuntu/docker-class/output.txt