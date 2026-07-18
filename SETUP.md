# Fresh Ubuntu WSL Setup

Use this guide after unregistering Ubuntu and installing a fresh WSL distro.

---

## 1. Optional: Back Up the Current Ubuntu Install

Run these commands in **Windows PowerShell**, not inside Ubuntu:

```powershell
wsl --shutdown

New-Item -ItemType Directory -Force -Path E:\WSL\Backups

wsl --export Ubuntu E:\WSL\Backups\ubuntu-before-fresh-install.tar
```

Verify the backup:

```powershell
Get-Item E:\WSL\Backups\ubuntu-before-fresh-install.tar
```

---

## 2. Unregister and Reinstall Ubuntu

Run in **Windows PowerShell**:

```powershell
wsl --unregister Ubuntu
wsl --install -d Ubuntu
```

Open Ubuntu after installation.

Create the Linux user:

```text
avee
```

Do not use `root` as your normal user.

---

## 3. Install the Minimum Required Tools

Run inside the new Ubuntu terminal:

```bash
sudo apt update
sudo apt install -y git gh curl ca-certificates
```

---

## 4. Configure Git

```bash
git config --global user.name "aveegras"
git config --global user.email "aveegras@gmail.com"
git config --global init.defaultBranch main
```

Verify:

```bash
git config --global --list
```

---

## 5. Authenticate GitHub

Run:

```bash
gh auth login
```

Choose:

```text
GitHub.com
SSH
Login with a web browser
```

Then run:

```bash
gh auth setup-git
gh auth status
```

Verify SSH access:

```bash
ssh -T git@github.com
```

A successful response should look similar to:

```text
Hi aveegras! You've successfully authenticated, but GitHub does not provide shell access.
```

---

## 6. Clone the Dotfiles Repository

```bash
git clone git@github.com:aveegras/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

---

## 7. Install the Complete Environment

```bash
./install.sh
```

This should install and configure:

- Zsh
- Starship
- Git and GitHub CLI
- Node.js LTS through fnm
- npm
- pnpm
- Bun
- Python
- uv
- fzf
- zoxide
- ripgrep
- fd
- bat
- direnv
- shellcheck
- Other packages listed in `packages/apt.txt`

---

## 8. Restart Into Zsh

```bash
exec zsh
```

If the shell still does not change, close Ubuntu completely and open it again.

Verify:

```bash
echo "$SHELL"
```

Expected:

```text
/usr/bin/zsh
```

---

## 9. Verify the Installation

```bash
cd ~/dotfiles

./dotfiles doctor
./check.sh
```

Check the main development tools:

```bash
printf '\n=== SHELL ===\n'
echo "$SHELL"

printf '\n=== JAVASCRIPT ===\n'
fnm --version
node --version
npm --version
pnpm --version
bun --version

printf '\n=== PYTHON ===\n'
python3 --version
uv --version

printf '\n=== TERMINAL TOOLS ===\n'
zsh --version
starship --version
zoxide --version
fzf --version
rg --version | head -n 1
fdfind --version
batcat --version
direnv --version

printf '\n=== GITHUB ===\n'
gh auth status
```

---

## 10. Normal Commands

Install everything on a fresh machine:

```bash
cd ~/dotfiles
./install.sh
```

Update Ubuntu and installed tools:

```bash
cd ~/dotfiles
./update.sh
```

Validate the dotfiles repository:

```bash
cd ~/dotfiles
./check.sh
```

Diagnose the current machine:

```bash
cd ~/dotfiles
./dotfiles doctor
```

---

## 11. Push Dotfiles Changes

After changing the dotfiles:

```bash
cd ~/dotfiles

./check.sh

git add -A
git status
git commit -m "update dotfiles"
git push origin main
```

---

## Minimal Fresh-Install Flow

After Ubuntu is installed, the essential setup is:

```bash
sudo apt update &&
sudo apt install -y git gh curl ca-certificates
```

Then authenticate:

```bash
gh auth login
gh auth setup-git
```

Then clone and install:

```bash
git clone git@github.com:aveegras/dotfiles.git ~/dotfiles &&
cd ~/dotfiles &&
./install.sh
```

Finally:

```bash
exec zsh
```

---

## Recovery Notes

Existing configuration files replaced by the dotfiles installer are backed up under:

```text
~/.dotfiles-backups/
```

List backups:

```bash
find ~/.dotfiles-backups -maxdepth 4 -type f
```

Machine-specific Zsh settings should go in:

```text
~/.zshrc.local
```

Do not commit API keys, tokens, passwords, or other secrets to the dotfiles repository.
