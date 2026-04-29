#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$ROOT_DIR"

if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
fi

docker compose up -d --build

echo "Fair Online 已启动"
echo "访问地址: http://localhost:${FAIR_ONLINE_PORT:-8080}"
