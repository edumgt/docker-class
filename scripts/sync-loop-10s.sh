#!/bin/bash
# Cron only supports 1-minute resolution, so this wrapper is invoked once a
# minute and internally re-runs the sync every 10 seconds (6 times).
set -euo pipefail

SCRIPT_DIR="/home/ubuntu/docker-class/scripts"
LOCK_FILE="/tmp/data1-to-data2-sync.lock"

exec 200>"$LOCK_FILE"
flock -n 200 || exit 0

for _ in $(seq 1 6); do
    "$SCRIPT_DIR/sync-data1-to-data2.sh"
    sleep 10
done
