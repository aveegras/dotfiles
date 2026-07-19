# ─── PATH ────────────────────────────────────────────────────────────────────

export BUN_INSTALL="$HOME/.bun"

typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.local/share/pnpm"
  "$BUN_INSTALL/bin"
  $path
)

export PATH

# ─── HISTORY ─────────────────────────────────────────────────────────────────

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INTERACTIVE_COMMENTS
setopt AUTO_CD

# ─── EDITING AND HISTORY SEARCH ──────────────────────────────────────────────

bindkey -e

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey '^[f' forward-word
bindkey '^[b' backward-word

# ─── COMPLETION ──────────────────────────────────────────────────────────────

ZSH_PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

mkdir -p "$ZSH_CACHE_DIR"

if [[ -d "$ZSH_PLUGIN_DIR/zsh-completions/src" ]]; then
  fpath=("$ZSH_PLUGIN_DIR/zsh-completions/src" $fpath)
fi

zmodload zsh/complist
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcompdump"

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/completion"
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':completion:*' squeeze-slashes true

# ─── FZF KEY BINDINGS ────────────────────────────────────────────────────────

if [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [[ -r "$HOME/.fzf/shell/key-bindings.zsh" ]]; then
  source "$HOME/.fzf/shell/key-bindings.zsh"
fi

# ─── FUZZY TAB COMPLETION ────────────────────────────────────────────────────

if [[ -r "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh"
fi

zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*' \
  fzf-preview 'ls -la --color=always $realpath'

# ─── AUTOSUGGESTIONS ─────────────────────────────────────────────────────────

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50

if [[ -r "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# ─── TOOL INTEGRATIONS ───────────────────────────────────────────────────────

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

command -v fnm >/dev/null 2>&1 &&
  eval "$(fnm env --use-on-cd --shell zsh)"

command -v zoxide >/dev/null 2>&1 &&
  eval "$(zoxide init zsh)"

command -v direnv >/dev/null 2>&1 &&
  eval "$(direnv hook zsh)"

# Ubuntu package command names

if ! command -v fd >/dev/null 2>&1 &&
  command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi

if ! command -v bat >/dev/null 2>&1 &&
  command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
fi

# ─── SHORTCUTS ───────────────────────────────────────────────────────────────

alias ll='ls -lah --group-directories-first'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'

alias reload='exec zsh'
alias dotfiles='cd "$HOME/dotfiles"'

alias gst='git status --short --branch'
alias gl='git log --oneline --decorate --graph -20'

mkcd() {
  [[ $# -eq 1 ]] || {
    print -u2 'Usage: mkcd <directory>'
    return 2
  }

  mkdir -p -- "$1" && cd -- "$1"
}

# ─── PROMPT ──────────────────────────────────────────────────────────────────

command -v starship >/dev/null 2>&1 &&
  eval "$(starship init zsh)"

# Machine-specific settings and secrets

[[ -r "$HOME/.zshrc.local" ]] &&
  source "$HOME/.zshrc.local"

# Syntax highlighting must remain last.

if [[ -r "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
