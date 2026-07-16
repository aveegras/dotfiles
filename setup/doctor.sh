#!/usr/bin/env bash

set -uo pipefail

failures=0

check() {
  local name="$1"
  shift

  if output="$("$@" 2>&1)"; then
    printf '✓ %-22s %s\n' "$name" "$(printf '%s' "$output" | head -n 1)"
  else
    printf '✗ %-22s failed\n' "$name"
    failures=$((failures + 1))
  fi
}

printf '\n=== DEVELOPMENT ENVIRONMENT ===\n'

check "Git" git --version
check "GitHub CLI" gh --version
check "Zsh" zsh --version
check "fnm" fnm --version
check "Node.js" node --version
check "npm" npm --version
check "pnpm" pnpm --version
check "Bun" bun --version
check "TypeScript" tsc --version
check "tsx" tsx --version
check "Biome" biome --version
check "Python" python --version
check "pipx" pipx --version
check "Rust" rustc --version
check "Cargo" cargo --version
check "Docker" docker --version
check "Docker Compose" docker compose version
check "Podman" podman --version
check "zoxide" zoxide --version
check "fzf" fzf --version
check "direnv" direnv version
check "ripgrep" rg --version
check "fd" fd --version
check "bat" bat --version
check "VS Code" code --version

printf '\n=== SERVICES AND LINKS ===\n'

check "Docker service" systemctl is-active docker
check "Snap service" systemctl is-active snapd.socket
check "GitHub account" gh api user --jq .login

if [[ -L "$HOME/.zshrc" ]]; then
  printf '✓ %-22s %s\n' ".zshrc symlink" "$(readlink -f "$HOME/.zshrc")"
else
  printf '✗ %-22s not a symlink\n' ".zshrc symlink"
  failures=$((failures + 1))
fi

if [[ -L "$HOME/.gitconfig" ]]; then
  printf '✓ %-22s %s\n' ".gitconfig symlink" "$(readlink -f "$HOME/.gitconfig")"
else
  printf '✗ %-22s not a symlink\n' ".gitconfig symlink"
  failures=$((failures + 1))
fi

printf '\n'

if (( failures > 0 )); then
  printf 'Environment check completed with %d failure(s).\n' "$failures"
  exit 1
fi

printf 'Environment check passed.\n'
