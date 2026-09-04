#!/bin/bash
# Every 2 hours: snapshot the running pg-stock container via `docker commit`
# and push it to Docker Hub as a backup.
#
# Caveat: committing a live container is a crash-consistent (not
# transactionally clean) snapshot — fine for a rolling backup, but a
# `pg_dump`-based image would be safer if point-in-time consistency matters.
set -euo pipefail

CONTAINER="pg-stock"
REPO="edumgt/pg-stock-backup"
SCRIPT_DIR="/home/ubuntu/docker-class/scripts"
LOG_FILE="$SCRIPT_DIR/backup_pg_to_dockerhub.log"
LOCK_FILE="/tmp/backup-pg-to-dockerhub.lock"

exec 200>"$LOCK_FILE"
flock -n 200 || exit 0

{
    echo "$(date '+%F %T') run start"
    TAG="$(date '+%Y%m%d-%H%M')"
    docker commit "$CONTAINER" "$REPO:$TAG"
    docker tag "$REPO:$TAG" "$REPO:latest"
    docker push "$REPO:$TAG"
    docker push "$REPO:latest"
    echo "$(date '+%F %T') run end"
} >> "$LOG_FILE" 2>&1
