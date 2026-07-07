if ! infocmp "$TERM" >/dev/null 2>&1; then
  export TERM=xterm-256color
fi

# Enable Powerlevel10k instant prompt. Keep this near the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit and shell plugins.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

autoload -Uz compinit && compinit

# Keybindings.
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# History.
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
[[ -n "$LS_COLORS" ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -a --tree --level=1 --icons=always --group-directories-first $realpath 2>/dev/null || ls --color=auto $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -a --tree --level=1 --icons=always --group-directories-first $realpath 2>/dev/null || ls --color=auto $realpath'

# Paths.
path=(${path:#$HOME/.rbenv/shims})
path=(${path:#$HOME/.rvm/bin})
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Editor.
export EDITOR='nvim'
export VISUAL='nvim'

# Aliases.
alias v='nvim'
alias vb='NVIM_APPNAME=nvim-bare nvim'
alias clear='clear -x'
alias c='clear'
alias nf='fastfetch'
alias ff='fastfetch'
alias ls='eza -a --tree --level=1 --icons=always --group-directories-first'
alias ll='eza -l --icons=always --no-permissions --no-user --no-time'
alias lt='eza -a --tree --level=1 --icons=always --group-directories-first'
alias lg='lazygit'
alias pf='v ~/.zshrc'
alias pr='source ~/.zshrc'

# Rails.
alias rc='bin/rails console'
alias rs='bin/rails server'

# Git.
alias gc='git checkout .'
alias gp='git pull'
alias gf='git fetch'
alias gsd='git switch develop'
alias gs='git switch'

# Tool initialization.
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
  # Put shims on PATH so mise tools resolve everywhere (shebangs, scripts, non-interactive, IDEs),
  # not just inside the interactive activate hook.
  export PATH="$HOME/.local/share/mise/shims:$PATH"
fi

# Yazi file manager.
function y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Prompt.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
