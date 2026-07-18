#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

error_handler() {
	local exit_code=$?
	printf '\nInstallation failed near line %s.\n' "${BASH_LINENO[0]}" >&2
	printf 'Fix the error, then run ./install.sh again.\n' >&2
	exit "$exit_code"
}

trap error_handler ERR

heading() {
	printf '\n========================================\n'
	printf '%s\n' "$1"
	printf '========================================\n'
}

if [[ "$(id -u)" -eq 0 ]]; then
	printf 'Do not run this script as root.\n' >&2
	printf 'Run it normally: ./install.sh\n' >&2
	exit 1
fi

cd "$ROOT"

heading "1/3 Installing system packages and configuration"

if [[ ! -x "$ROOT/dotfiles" ]]; then
	printf 'Missing executable: %s/dotfiles\n' "$ROOT" >&2
	exit 1
fi

"$ROOT/dotfiles" all

heading "2/3 Installing web-development tools"

if [[ ! -x "$ROOT/tools/install-web.sh" ]]; then
	printf 'Missing executable: %s/tools/install-web.sh\n' "$ROOT" >&2
	exit 1
fi

"$ROOT/tools/install-web.sh"

heading "3/3 Verifying installation"

export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
export PATH="$PNPM_HOME:$BUN_INSTALL/bin:$HOME/.local/share/fnm:$HOME/.local/bin:$PATH"

if command -v fnm >/dev/null 2>&1; then
	eval "$(fnm env --shell bash)"
fi

"$ROOT/dotfiles" doctor

printf '\nWeb-development tools:\n'

for command_name in node npm pnpm bun uv; do
	if command -v "$command_name" >/dev/null 2>&1; then
		printf '✓ %-8s %s\n' \
			"$command_name" \
			"$("$command_name" --version | head -n 1)"
	else
		printf '✗ %-8s missing\n' "$command_name"
	fi
done

printf '\nInstallation complete.\n'
printf 'Restart Ubuntu, or run:\n\n'
printf '  exec zsh\n\n'
