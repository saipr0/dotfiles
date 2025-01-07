#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# customization

cat ~/.cache/wal/sequences
if [[ $(tty) == *"pts"* ]]; then
    fastfetch --config ~/.config/fastfetch/config.jsonc
    # fastfetch --config examples/8
else
    echo
    if [ -f /bin/qtile ]; then
        echo "Start Qtile X11 with command Qtile"
    fi
    if [ -f /bin/hyprctl ]; then
        echo "Start Hyprland with command Hyprland"
    fi
fi

# alias
alias c='clear'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias ls='eza --icons=always'
alias ll='eza -l --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias vim='$EDITOR'
alias wifi='nmtui'

# path

export EDITOR=nvim
PATH=$PATH:/home/saipr/.local/bin

eval "$(oh-my-posh init bash --config /home/saipr/.config/ohmyposh/zen.toml)"

# init

eval "$(fzf --bash)"
eval "$(zoxide init bash)"

# yazi

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Set up Node Version Manager
source /usr/share/nvm/init-nvm.sh
