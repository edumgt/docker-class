import ipaddress
import os
import socket
from pathlib import Path
from urllib.parse import urlparse
from uuid import uuid4

import docker
from docker.errors import ContainerError, DockerException, ImageNotFound
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel


RESULTS_DIR = Path(os.environ.get("RESULTS_DIR", "/data"))
RESULTS_VOLUME = os.environ.get("RESULTS_VOLUME", "capture-results")
CAPTURE_IMAGE = os.environ.get("CAPTURE_IMAGE", "local/capture-runner:latest")
OCR_IMAGE = os.environ.get("OCR_IMAGE", "local/ocr-runner:latest")

app = FastAPI(title="Docker Capture OCR API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=os.environ.get("CORS_ORIGINS", "*").split(","),
    allow_methods=["POST"],
    allow_headers=["*"],
)


class CaptureRequest(BaseModel):
    url: str


class CaptureResult(BaseModel):
    job_id: str
    screenshot_url: str
    ocr_text: str
    rendered_text: str


def validate_url(value: str) -> str:
    parsed = urlparse(value)
    if parsed.scheme not in {"http", "https"} or not parsed.hostname:
        raise HTTPException(422, "http 또는 https URL을 입력하세요.")

    # Avoid giving the Docker runner access to localhost or private network ranges.
    try:
        addresses = {item[4][0] for item in socket.getaddrinfo(parsed.hostname, None)}
    except socket.gaierror as error:
        raise HTTPException(422, "호스트 이름을 확인할 수 없습니다.") from error
    for address in addresses:
        ip = ipaddress.ip_address(address)
        if ip.is_private or ip.is_loopback or ip.is_link_local or ip.is_reserved:
            raise HTTPException(422, "공개 웹사이트 URL만 캡처할 수 있습니다.")
    return value


def run_container(image: str, *, command: list[str] | None = None, environment: dict[str, str] | None = None) -> None:
    try:
        client = docker.from_env()
        is_capture = image == CAPTURE_IMAGE
        options = dict(
            image=image,
            command=command,
            environment=environment,
            volumes={RESULTS_VOLUME: {"bind": "/out" if is_capture else "/data", "mode": "rw"}},
            network_mode="bridge",
            detach=True,
            remove=False,
            user="0:0",
        )
        if is_capture:
            options["shm_size"] = "1g"
        container = client.containers.run(**options)
        try:
            result = container.wait()
            if result["StatusCode"] != 0:
                logs = container.logs(tail=100).decode("utf-8", errors="replace")
                raise RuntimeError(logs or f"컨테이너가 종료 코드 {result['StatusCode']}로 실패했습니다.")
        finally:
            container.remove(force=True)
    except (DockerException, ImageNotFound, ContainerError, RuntimeError) as error:
        raise HTTPException(502, f"컨테이너 작업 실패: {error}") from error


@app.post("/api/capture", response_model=CaptureResult)
def capture(request: CaptureRequest) -> CaptureResult:
    url = validate_url(request.url)
    job_id = uuid4().hex
    job_dir = RESULTS_DIR / job_id
    job_dir.mkdir(parents=True, exist_ok=False)

    run_container(
        CAPTURE_IMAGE,
        environment={"CAPTURE_URL": url, "OUTPUT_DIR": f"/out/{job_id}"},
    )
    run_container(
        OCR_IMAGE,
        command=[
            f"/data/{job_id}/screenshot.png",
            f"/data/{job_id}/ocr",
            "-l",
            "kor+eng",
            "--tessdata-dir",
            "/usr/local/share/tessdata",
        ],
    )

    try:
        return CaptureResult(
            job_id=job_id,
            screenshot_url=f"/results/{job_id}/screenshot.png",
            ocr_text=(job_dir / "ocr.txt").read_text(encoding="utf-8"),
            rendered_text=(job_dir / "rendered-text.txt").read_text(encoding="utf-8"),
        )
    except OSError as error:
        raise HTTPException(502, "컨테이너 결과 파일을 읽지 못했습니다.") from error


RESULTS_DIR.mkdir(parents=True, exist_ok=True)
app.mount("/results", StaticFiles(directory=RESULTS_DIR), name="results")
