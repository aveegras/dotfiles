#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILE="$SCRIPT_DIR/apt-packages.txt"

log() {
  printf '\n\033[1;36m==> %s\033[0m\n' "$1"
}

if [[ ! -f "$PACKAGE_FILE" ]]; then
  echo "Missing package list: $PACKAGE_FILE" >&2
  exit 1
fi

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run this script as your normal user, not as root." >&2
  exit 1
fi

if ! grep -qi microsoft /proc/version; then
  echo "Warning: this environment does not appear to be WSL."
fi

log "Updating Ubuntu package metadata"
sudo apt update

log "Upgrading existing Ubuntu packages"
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

log "Installing base packages"
sudo DEBIAN_FRONTEND=noninteractive xargs -a "$PACKAGE_FILE" apt install -y

log "Adding the GitHub CLI repository"
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null

sudo chmod a+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

log "Removing packages that conflict with Docker Engine"
sudo apt remove -y \
  docker.io \
  docker-compose \
  docker-compose-v2 \
  docker-doc \
  podman-docker \
  containerd \
  runc 2>/dev/null || true

log "Adding the Docker repository"
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

source /etc/os-release

sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<DOCKER_REPOSITORY
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${UBUNTU_CODENAME:-$VERSION_CODENAME}
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
DOCKER_REPOSITORY

log "Installing GitHub CLI and Docker"
sudo apt update

sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  gh \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

log "Enabling system services"
sudo systemctl enable --now docker
sudo systemctl enable --now snapd.socket

log "Adding the current user to the Docker group"
sudo usermod -aG docker "$USER"

log "Configuring Git LFS"
git lfs install

log "Creating user executable directory"
mkdir -p "$HOME/.local/bin"

ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"

log "System bootstrap complete"

printf '\nRestart WSL before using Docker without sudo:\n'
printf '  1. Close Ubuntu\n'
printf '  2. Run wsl --shutdown from PowerShell\n'
printf '  3. Open Ubuntu again\n'
