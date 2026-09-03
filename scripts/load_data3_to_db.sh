#!/bin/bash
# Hourly job: load data-3 CSVs into pg-stock without duplicating rows
# (dedup enforced by the ohlcv table's PK + ON CONFLICT DO NOTHING).
set -euo pipefail

VENV_DIR="/home/ubuntu/venvs/stock-ohlcv"
SCRIPT_DIR="/home/ubuntu/docker-class/scripts"
LOG_FILE="$SCRIPT_DIR/load_data3_to_db.log"
LOCK_FILE="/tmp/load-data3-to-db.lock"

exec 200>"$LOCK_FILE"
flock -n 200 || exit 0

{
    echo "$(date '+%F %T') run start"
    "$VENV_DIR/bin/python" "$SCRIPT_DIR/load_data3_to_db.py"
    echo "$(date '+%F %T') run end"
} >> "$LOG_FILE" 2>&1
