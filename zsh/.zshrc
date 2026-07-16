# ==================================================
# Environment directories
# ==================================================

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p "$XDG_CACHE_HOME/zsh"

# ==================================================
# Executable paths
# ==================================================

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"

export BUN_INSTALL="$HOME/.local/share/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOME/.local/share/fnm:$PATH"

# Remove duplicate PATH entries.
typeset -U path PATH

# ==================================================
# Zsh history
# ==================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt EXTENDED_HISTORY

# ==================================================
# Shell behaviour
# ==================================================

bindkey -e

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
setopt CORRECT

unsetopt BEEP

# ==================================================
# Completion
# ==================================================

autoload -Uz compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|=*' \
  'l:|=* r:|=*'

compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# ==================================================
# fzf
#
# Ctrl+R: command history
# Ctrl+T: files
# Alt+C: directories
# ==================================================

if [[ -r /usr/share/doc/fzf/examples/completion.zsh ]]; then
  source /usr/share/doc/fzf/examples/completion.zsh
fi

if [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# ==================================================
# zoxide
#
# Example: z counterforme
# ==================================================

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# ==================================================
# direnv
# ==================================================

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# ==================================================
# Node.js: fnm
#
# Automatically reads .node-version when changing
# project directories.
# ==================================================

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ==================================================
# Useful aliases
# ==================================================

alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

alias cat='bat'
alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias lg='git log --oneline --graph --decorate --all'

alias dc='docker compose'
alias pc='podman compose'

alias pn='pnpm'
alias pnx='pnpm dlx'

# ==================================================
# Prompt
# ==================================================

autoload -Uz colors
colors

PROMPT='%F{cyan}%n%f %F{blue}%~%f %# '

# ==================================================
# Autosuggestions
# ==================================================

if [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax highlighting must be loaded last.
if [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
