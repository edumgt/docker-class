#!/bin/bash
# Sync new/changed files from data-2 to data-3 (no duplicates: rsync --update
# only transfers files that are new or newer than the destination copy).
set -euo pipefail

SRC_DIR="/home/ubuntu/docker-class/data-2/"
DST_DIR="/home/ubuntu/docker-class/data-3/"
LOG_FILE="/home/ubuntu/docker-class/scripts/sync-data2-to-data3.log"

CHANGES=$(rsync -a --update --out-format="%n" "$SRC_DIR" "$DST_DIR")

if [ -n "$CHANGES" ]; then
    while IFS= read -r file; do
        echo "$(date '+%F %T') synced: $file" >> "$LOG_FILE"
    done <<< "$CHANGES"
fi
