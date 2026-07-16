#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
VERSIONS_FILE="$SCRIPT_DIR/tool-versions.txt"

COREPACK_VERSION="0.35.0"
TYPESCRIPT_LANGUAGE_SERVER_VERSION="5.3.0"

log() {
  printf '\n\033[1;36m==> %s\033[0m\n' "$1"
}

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run this script as your normal user, not as root." >&2
  exit 1
fi

if [[ ! -f "$VERSIONS_FILE" ]]; then
  echo "Missing versions file: $VERSIONS_FILE" >&2
  exit 1
fi

# Load values such as node=24.18.0 and pnpm=11.13.0.
# shellcheck disable=SC1090
source "$VERSIONS_FILE"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p \
  "$HOME/.local/bin" \
  "$HOME/.local/share" \
  "$HOME/.config"

log "Installing fnm ${fnm}"
curl -fsSL https://fnm.vercel.app/install \
  | bash -s -- --skip-shell

export PATH="$HOME/.local/share/fnm:$PATH"

if ! command -v fnm >/dev/null 2>&1; then
  echo "fnm installation failed." >&2
  exit 1
fi

log "Installing Node.js ${node}"
fnm install "$node"
fnm default "$node"

eval "$(fnm env --shell bash)"
fnm use "$node"

log "Installing Corepack ${COREPACK_VERSION}"
npm install --global "corepack@${COREPACK_VERSION}"

log "Installing pnpm ${pnpm}"
corepack enable pnpm
corepack install --global "pnpm@${pnpm}"

export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"

mkdir -p "$PNPM_HOME/bin"
pnpm config set global-bin-dir "$PNPM_HOME/bin"

log "Installing global TypeScript and Biome tools"
pnpm add --global \
  "typescript@${typescript}" \
  "tsx@${tsx}" \
  "typescript-language-server@${TYPESCRIPT_LANGUAGE_SERVER_VERSION}" \
  "@biomejs/biome@${biome}"

log "Installing Bun ${bun}"
export BUN_INSTALL="$HOME/.local/share/bun"

curl -fsSL https://bun.com/install \
  | bash -s -- "bun-v${bun}"

export PATH="$BUN_INSTALL/bin:$PATH"

log "Installing Rust ${rust}"
if [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --profile minimal --default-toolchain none
fi

export PATH="$HOME/.cargo/bin:$PATH"

rustup toolchain install "$rust" \
  --profile minimal \
  --component rustfmt \
  --component clippy

rustup default "$rust"

log "Linking dotfiles with GNU Stow"
if [[ -e "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  backup="$HOME/.zshrc.before-dotfiles-$(date +%Y%m%d-%H%M%S)"
  mv "$HOME/.zshrc" "$backup"
  echo "Existing .zshrc moved to: $backup"
fi

(
  cd "$DOTFILES_DIR"
  stow --restow --target="$HOME" zsh
)

log "Setting Zsh as the login shell"
zsh_path="$(command -v zsh)"

if [[ "${SHELL:-}" != "$zsh_path" ]]; then
  chsh -s "$zsh_path"
fi

log "Verifying installed tools"
printf 'fnm:       %s\n' "$(fnm --version)"
printf 'node:      %s\n' "$(node --version)"
printf 'npm:       %s\n' "$(npm --version)"
printf 'pnpm:      %s\n' "$(pnpm --version)"
printf 'bun:       %s\n' "$(bun --version)"
printf 'rustc:     %s\n' "$(rustc --version)"
printf 'cargo:     %s\n' "$(cargo --version)"
printf 'tsc:       %s\n' "$(tsc --version)"
printf 'tsx:       %s\n' "$(tsx --version)"
printf 'biome:     %s\n' "$(biome --version)"

printf '\nUser development environment installation complete.\n'
printf 'Close and reopen the terminal to start Zsh cleanly.\n'
