#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/tool-versions.txt"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

commands=(
  git
  gh
  zsh
  fnm
  node
  npm
  pnpm
  bun
  python
  pipx
  rustc
  cargo
  tsc
  tsx
  biome
  docker
  podman
  zoxide
  fzf
  direnv
)

for command_name in "${commands[@]}"; do
  require_command "$command_name"
done

cat > "$OUTPUT_FILE" <<VERSIONS
ubuntu=$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
kernel=$(uname -r)

git=$(git --version | awk '{print $3}')
gh=$(gh --version | head -n 1 | awk '{print $3}')

zsh=$(zsh --version | awk '{print $2}')
fnm=$(fnm --version | awk '{print $2}')
node=$(node --version | sed 's/^v//')
npm=$(npm --version)
pnpm=$(pnpm --version)
bun=$(bun --version)

python=$(python --version | awk '{print $2}')
pipx=$(pipx --version)

rust=$(rustc --version | awk '{print $2}')
cargo=$(cargo --version | awk '{print $2}')

typescript=$(tsc --version | awk '{print $2}')
tsx=$(tsx --version | awk '{print $2}')
biome=$(biome --version | awk '{print $2}')

docker=$(docker --version | awk '{print $3}' | tr -d ',')
docker_compose=$(docker compose version --short)
podman=$(podman --version | awk '{print $3}')

zoxide=$(zoxide --version | awk '{print $2}')
fzf=$(fzf --version | awk '{print $1}')
direnv=$(direnv version)
VERSIONS

echo "Updated: $OUTPUT_FILE"
