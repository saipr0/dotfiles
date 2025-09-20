# Path configuration
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:/opt/homebrew/opt/libpq/bin:$PATH

# Editor configuration
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Aliases
alias v="nvim"
alias vim="nvim"
alias c='clear'
alias nf='fastfetch'
alias ff='fastfetch'
alias ls='eza -a --tree --level=1 --icons=always --group-directories-first'
alias ll='eza -l --icons=always --no-permissions --no-user --no-time '
alias lt='eza -a --tree --level=1 --icons=always --group-directories-first'
alias shutdown='systemctl poweroff'
alias lg='lazygit'
alias pf='v ~/.zshrc'
alias pr='source ~/.zshrc'

# rails aliases
alias rc='bin/rails console'
alias rg='rails generate'
alias rs='bin/rails server'
# tnt specific
alias tg="/Users/saipr/Documents/tntinfra/scripts/toggle_gems.sh"
alias te="/Users/saipr/Documents/tntinfra/scripts/toggle_env.sh"

# git
alias gc='git checkout .'
alias gp='git pull'
alias gf='git fetch'
alias gsd='git switch develop'
alias gs='git switch'

# Aliases: tmux
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'
alias ts='$HOME/.config/scripts/tmux-sessionizer.sh'

# Initialize tools
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# Yazi file manager function
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# ohmyposh
eval "$(oh-my-posh init zsh --config 'robbyrussell')"

# postgresql
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="$PATH:/Users/saipr/Documents/worldbanc/private/bin"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
