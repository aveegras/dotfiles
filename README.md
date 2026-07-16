# Avee's WSL Development Environment

Reproducible Ubuntu WSL setup for Counterforme, Clayd, CFX, and other development projects.

## Setup

1. Run ./setup/bootstrap-system.sh
2. Restart WSL
3. Run ./setup/bootstrap-user.sh

This environment uses pnpm and Biome. ESLint is intentionally not installed.

## Install on another WSL machine

```sh
git clone "git@github.com:aveegras/dotfiles.git" ~/dotfiles
cd ~/dotfiles
./setup/bootstrap-system.sh
```

Restart WSL from PowerShell:

```powershell
wsl --shutdown
```

Then reopen Ubuntu and run:

```sh
cd ~/dotfiles
./setup/bootstrap-user.sh
```
