export PATH="$HOME/.local/bin:$HOME/.local/share/pnpm:$PATH"

export EDITOR="nano"
export VISUAL="$EDITOR"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

autoload -Uz compinit
compinit

bindkey -e

alias ll="ls -alF"
alias la="ls -A"
alias ..="cd .."
alias ...="cd ../.."

alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate -15"

if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init zsh)"
fi

if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
	source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
	source /usr/share/doc/fzf/examples/completion.zsh
fi

PROMPT='%F{cyan}%n%f %F{blue}%~%f %# '

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
