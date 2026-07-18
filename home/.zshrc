# --------------------------------------------------
# PATHS
# --------------------------------------------------

export PNPM_HOME="$HOME/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"

export PATH="$PNPM_HOME:$BUN_INSTALL/bin:$HOME/.local/share/fnm:$HOME/.local/bin:$PATH"

# --------------------------------------------------
# DEFAULT PROGRAMS
# --------------------------------------------------

export EDITOR="nano"
export VISUAL="$EDITOR"
export PAGER="less"

# --------------------------------------------------
# HISTORY
# --------------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# --------------------------------------------------
# COMPLETION
# --------------------------------------------------

autoload -Uz compinit
mkdir -p "$HOME/.cache/zsh"
compinit -d "$HOME/.cache/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --------------------------------------------------
# KEYBOARD
# --------------------------------------------------

bindkey -e

# --------------------------------------------------
# ALIASES
# --------------------------------------------------

alias ll="ls -lah"
alias la="ls -A"
alias ..="cd .."
alias ...="cd ../.."

alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate -15"

command -v batcat >/dev/null 2>&1 && alias bat="batcat"
command -v fdfind >/dev/null 2>&1 && alias fd="fdfind"

# --------------------------------------------------
# TOOL INITIALIZATION
# --------------------------------------------------

if command -v fnm >/dev/null 2>&1; then
	eval "$(fnm env --use-on-cd --shell zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
	eval "$(direnv hook zsh)"
fi

if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
	source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
	source /usr/share/doc/fzf/examples/completion.zsh
fi

if command -v starship >/dev/null 2>&1; then
	eval "$(starship init zsh)"
else
	PROMPT='%F{cyan}%n%f %F{blue}%~%f %# '
fi

# Private machine-specific configuration.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# bun completions
[ -s "/home/avee/.bun/_bun" ] && source "/home/avee/.bun/_bun"
