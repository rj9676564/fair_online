#!/bin/sh
set -eu

IMAGE_NAME="${IMAGE_NAME:-fair-online-web}"
CONTAINER_NAME="${CONTAINER_NAME:-fair-online-web}"
HOST_PORT="${HOST_PORT:-8080}"
API_BASE_URL="${FAIR_ONLINE_API_BASE_URL:-/service/}"

docker build -t "$IMAGE_NAME" .

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

docker run -d \
  --name "$CONTAINER_NAME" \
  -p "${HOST_PORT}:80" \
  -e FAIR_ONLINE_API_BASE_URL="$API_BASE_URL" \
  "$IMAGE_NAME"
