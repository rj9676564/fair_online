#!/bin/sh
set -eu

flutter_bin="$(command -v flutter)"
dart_bin="$(command -v dart)"

resolve_flutter_sdk_path() {
  if [ -n "${FAIR_ONLINE_FLUTTER_SDK_PATH:-}" ]; then
    printf '%s\n' "$FAIR_ONLINE_FLUTTER_SDK_PATH"
    return
  fi

  if [ -n "${FLUTTER_ROOT:-}" ]; then
    printf '%s\n' "$FLUTTER_ROOT"
    return
  fi

  if command -v realpath >/dev/null 2>&1; then
    flutter_bin="$(realpath "$flutter_bin")"
    dart_bin="$(realpath "$dart_bin")"
  fi

  dart_sdk_path="$(dirname "$(dirname "$dart_bin")")"
  dart_candidate="$(dirname "$(dirname "$(dirname "$dart_sdk_path")")")"
  if [ -x "$dart_candidate/bin/flutter" ]; then
    printf '%s\n' "$dart_candidate"
    return
  fi

  flutter_candidate="$(dirname "$(dirname "$flutter_bin")")"
  if [ -x "$flutter_candidate/bin/flutter" ]; then
    printf '%s\n' "$flutter_candidate"
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
mkdir -p .fvm
ln -sfn "$FAIR_ONLINE_FLUTTER_SDK_PATH" .fvm/flutter_sdk
test -f .fvm/flutter_sdk/version
test -x .fvm/flutter_sdk/bin/flutter

exec dart run bin/server.dart "$@"
