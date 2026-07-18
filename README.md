# Dotfiles

Minimal Ubuntu WSL configuration.

## Fresh installation

```bash
git clone git@github.com:aveegras/dotfiles.git ~/dotfiles
cd ~/dotfiles
./dotfiles all
```

Restart Ubuntu after installation.

## Commands

```bash
./dotfiles install
./dotfiles link
./dotfiles git
./dotfiles shell
./dotfiles doctor
./dotfiles all
```

## Structure

```text
home/           configuration files
packages/       Ubuntu package list
dotfiles        setup command
```

Existing configuration files are backed up inside:

```text
~/.dotfiles-backups/
```

Machine-specific Zsh settings can be added to:

```text
~/.zshrc.local
```
