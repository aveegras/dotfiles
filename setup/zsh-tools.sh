#!/usr/bin/env bash
set -Eeuo pipefail

MODE="${1:-install}"

case "$MODE" in
  install|update) ;;
  *)
    printf 'Usage: %s [install|update]\n' "$0" >&2
    exit 2
    ;;
esac

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
LOCK_FILE="$ROOT_DIR/setup/zsh-plugins.lock"
TMP_LOCK="$(mktemp)"

trap 'rm -f "$TMP_LOCK"' EXIT

mkdir -p "$PLUGIN_DIR"

plugins=(
  'zsh-completions|https://github.com/zsh-users/zsh-completions.git'
  'fzf-tab|https://github.com/Aloxaf/fzf-tab.git'
  'zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions.git'
  'zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting.git'
)

locked_commit() {
  local name="$1"

  [[ -f "$LOCK_FILE" ]] || return 0

  awk -F '|' -v name="$name" \
    '$1 == name { print $3; exit }' \
    "$LOCK_FILE"
}

sync_plugin() {
  local spec="$1"
  local name url target commit

  IFS='|' read -r name url <<< "$spec"
  target="$PLUGIN_DIR/$name"

  if [[ ! -d "$target/.git" ]]; then
    rm -rf "$target"
    git clone --filter=blob:none --no-checkout "$url" "$target"
  fi

  if [[ "$MODE" == "update" ]]; then
    git -C "$target" fetch --force --depth=1 origin HEAD
    commit="$(git -C "$target" rev-parse FETCH_HEAD)"
  else
    commit="$(locked_commit "$name")"

    if [[ -n "$commit" ]]; then
      if ! git -C "$target" cat-file -e "${commit}^{commit}" 2>/dev/null; then
        git -C "$target" fetch --force origin "$commit"
      fi
    else
      git -C "$target" fetch --force --depth=1 origin HEAD
      commit="$(git -C "$target" rev-parse FETCH_HEAD)"
    fi
  fi

  git -C "$target" checkout --detach --force "$commit" >/dev/null

  printf '%s|%s|%s\n' "$name" "$url" "$commit" >> "$TMP_LOCK"
  printf 'ready: %s (%s)\n' "$name" "${commit:0:12}"
}

for plugin in "${plugins[@]}"; do
  sync_plugin "$plugin"
done

mv "$TMP_LOCK" "$LOCK_FILE"

rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"*

printf 'Zsh tooling %s complete.\n' "$MODE"
