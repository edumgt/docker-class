#!/bin/bash
# Sync new/changed files from data-1 to data-2.
set -euo pipefail

SRC_DIR="/home/ubuntu/docker-class/data-1/"
DST_DIR="/home/ubuntu/docker-class/data-2/"
LOG_FILE="/home/ubuntu/docker-class/scripts/sync.log"

CHANGES=$(rsync -a --update --out-format="%n" "$SRC_DIR" "$DST_DIR")

if [ -n "$CHANGES" ]; then
    while IFS= read -r file; do
        echo "$(date '+%F %T') synced: $file" >> "$LOG_FILE"
    done <<< "$CHANGES"
fi
