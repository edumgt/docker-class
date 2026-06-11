#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${JENKINS_INSTALL_LOG:-/var/jenkins_home/logs/jenkins-startup.log}"
mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"

python3 /usr/local/bin/sse_log_server.py --host 127.0.0.1 --port 18080 --log-file "$LOG_FILE" &
SSE_PID=$!

nginx -g 'daemon off;' &
NGINX_PID=$!

cleanup() {
  kill "$SSE_PID" "$NGINX_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

set -o pipefail
/usr/local/bin/jenkins.sh 2>&1 | tee -a "$LOG_FILE"
