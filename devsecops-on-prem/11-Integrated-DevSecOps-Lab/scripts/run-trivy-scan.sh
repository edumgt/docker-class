#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${1:-vuln-demo:latest}"

cd "$(dirname "$0")/.."

docker build -t "$IMAGE_NAME" ./dockerfiles/vuln-demo

docker compose run --rm trivy trivy image --severity HIGH,CRITICAL --exit-code 1 "$IMAGE_NAME"
