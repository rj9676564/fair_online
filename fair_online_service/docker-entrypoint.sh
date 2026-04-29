#!/bin/sh
set -eu

flutter_bin="$(command -v flutter)"

resolve_flutter_sdk_path() {
  if [ -n "${FAIR_ONLINE_FLUTTER_SDK_PATH:-}" ]; then
    printf '%s\n' "$FAIR_ONLINE_FLUTTER_SDK_PATH"
    return
  fi

  if [ -n "${FLUTTER_ROOT:-}" ]; then
    printf '%s\n' "$FLUTTER_ROOT"
    return
  fi

  while [ -L "$flutter_bin" ]; do
    link_target="$(readlink "$flutter_bin")"
    case "$link_target" in
      /*) flutter_bin="$link_target" ;;
      *) flutter_bin="$(dirname "$flutter_bin")/$link_target" ;;
    esac
  done

  dirname "$(dirname "$flutter_bin")"
}

export FAIR_ONLINE_FLUTTER_SDK_PATH="$(resolve_flutter_sdk_path)"

exec dart run bin/server.dart "$@"
