#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
  echo "用法: $0 <target-dir>"
  exit 1
fi

ROOT_DIR=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TARGET_DIR=$1

mkdir -p "$TARGET_DIR"

copy_path() {
  src=$1
  dst=$2
  mkdir -p "$(dirname "$TARGET_DIR/$dst")"
  rsync -a --delete \
    --exclude '.git/' \
    --exclude '.DS_Store' \
    --exclude '.dart_tool/' \
    --exclude 'build/' \
    --exclude 'ios/Flutter/ephemeral/' \
    --exclude 'media_cache/' \
    "$ROOT_DIR/$src" "$TARGET_DIR/$dst"
}

copy_path ".github/" ".github/"
copy_path ".env.example" ".env.example"
copy_path "docker-compose.yml" "docker-compose.yml"
copy_path "scripts/" "scripts/"
copy_path "fair_online/" "fair_online/"
copy_path "fair_online_service/" "fair_online_service/"

if [ -f "$ROOT_DIR/README.md" ]; then
  copy_path "README.md" "README.md"
fi

cat >"$TARGET_DIR/.gitignore" <<'EOF'
.DS_Store
.env
**/.dart_tool/
**/.fvm/flutter_sdk
**/build/
**/ios/Flutter/ephemeral/
**/media_cache/
EOF

cat <<EOF
导出完成:
  源目录: $ROOT_DIR
  目标目录: $TARGET_DIR

后续建议执行:
  cd $TARGET_DIR
  git init
  git remote add origin git@github.com:rj9676564/fair_online.git
  git add .
  git commit -m "chore: initialize fair online platform"
  git push -u origin main
EOF
