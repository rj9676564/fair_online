#!/bin/sh
set -eu

API_BASE_URL="${FAIR_ONLINE_API_BASE_URL:-/service/}"

case "$API_BASE_URL" in
  */) ;;
  *) API_BASE_URL="${API_BASE_URL}/" ;;
esac

cat >/usr/share/nginx/html/config.js <<EOF
window.__FAIR_ONLINE_CONFIG__ = {
  apiBaseUrl: "${API_BASE_URL}"
};
EOF
