docker run --rm -v "$(pwd):/data" clearlinux/tesseract-ocr \
  tesseract ./a.pdf /data/ -l kor+eng