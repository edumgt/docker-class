#!/bin/bash
# Runs one batch of the KOSPI/KOSDAQ 2025 OHLCV gathering job.
# Invoked once a minute by cron; fetch_ohlcv.py tracks progress itself so
# concurrent/duplicate runs are avoided with a lock instead of relying on
# cron timing alone.
set -euo pipefail

VENV_DIR="/home/ubuntu/venvs/stock-ohlcv"
SCRIPT_DIR="/home/ubuntu/docker-class/scripts"
LOG_FILE="$SCRIPT_DIR/fetch_ohlcv.log"
LOCK_FILE="/tmp/fetch-ohlcv.lock"

exec 200>"$LOCK_FILE"
flock -n 200 || exit 0

{
    echo "$(date '+%F %T') run start"
    "$VENV_DIR/bin/python" "$SCRIPT_DIR/fetch_ohlcv.py"
    echo "$(date '+%F %T') run end"
} >> "$LOG_FILE" 2>&1
