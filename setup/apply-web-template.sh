#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(cd -- "$SCRIPT_DIR/../templates/web-project" && pwd)"
TARGET_DIR="${1:-$PWD}"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

TARGET_DIR="$(cd -- "$TARGET_DIR" && pwd)"

files=(
  ".editorconfig"
  ".gitattributes"
  ".gitignore"
  ".node-version"
  "biome.json"
)

printf 'Applying web-project baseline to:\n  %s\n\n' "$TARGET_DIR"

for file in "${files[@]}"; do
  source_file="$TEMPLATE_DIR/$file"
  target_file="$TARGET_DIR/$file"

  if [[ -e "$target_file" ]]; then
    printf 'skip   %s already exists\n' "$file"
  else
    cp "$source_file" "$target_file"
    printf 'create %s\n' "$file"
  fi
done

printf '\nBaseline applied.\n'
printf 'Existing files were not overwritten.\n'
