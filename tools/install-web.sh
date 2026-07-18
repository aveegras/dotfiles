#!/usr/bin/env bash

set -Eeuo pipefail

export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
export PATH="$PNPM_HOME:$BUN_INSTALL/bin:$HOME/.local/share/fnm:$HOME/.local/bin:$PATH"

heading() {
	printf '\n==> %s\n' "$1"
}

heading "Installing fnm"

if ! command -v fnm >/dev/null 2>&1; then
	curl -fsSL https://fnm.vercel.app/install |
		bash -s -- --skip-shell
else
	printf 'fnm is already installed.\n'
fi

export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --shell bash)"

heading "Installing the latest Node.js LTS"

fnm install --lts --use

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
fnm default "$NODE_MAJOR"

heading "Installing pnpm through Corepack"

npm install --global corepack@latest
corepack enable pnpm
pnpm --version

heading "Installing Bun"

if ! command -v bun >/dev/null 2>&1; then
	curl -fsSL https://bun.com/install | bash
else
	printf 'Bun is already installed.\n'
fi

heading "Installing uv"

if ! command -v uv >/dev/null 2>&1; then
	curl -LsSf https://astral.sh/uv/install.sh |
		env UV_NO_MODIFY_PATH=1 sh
else
	printf 'uv is already installed.\n'
fi

heading "Versions"

printf 'fnm:    %s\n' "$(fnm --version)"
printf 'node:   %s\n' "$(node --version)"
printf 'npm:    %s\n' "$(npm --version)"
printf 'pnpm:   %s\n' "$(pnpm --version)"
printf 'bun:    %s\n' "$("$HOME/.bun/bin/bun" --version)"
printf 'uv:     %s\n' "$("$HOME/.local/bin/uv" --version)"
