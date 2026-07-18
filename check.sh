#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

printf '\n==> Checking Bash syntax\n'

scripts=(
	dotfiles
	install.sh
	update.sh
	tools/install-web.sh
)

existing_scripts=()

for script in "${scripts[@]}"; do
	if [[ -f "$script" ]]; then
		bash -n "$script"
		existing_scripts+=("$script")
		printf '✓ %s\n' "$script"
	fi
done

printf '\n==> Running ShellCheck\n'

if command -v shellcheck >/dev/null 2>&1; then
	shellcheck -x "${existing_scripts[@]}"
	printf '✓ ShellCheck passed\n'
else
	printf '✗ shellcheck is missing\n' >&2
	exit 1
fi

printf '\n==> Checking Zsh configuration\n'

zsh -n home/.zshrc
printf '✓ home/.zshrc\n'

printf '\nAll checks passed.\n'
