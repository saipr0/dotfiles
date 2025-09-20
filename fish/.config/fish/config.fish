# Environment Variables
set -gx EDITOR nvim
if test -n "$SSH_CONNECTION"
    set -gx EDITOR vim
end
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml


# PATH configuration
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path /usr/local/bin
fish_add_path /opt/homebrew/opt/libpq/bin
fish_add_path /opt/homebrew/opt/postgresql@17/bin
fish_add_path /Users/saipr/Documents/worldbanc/private/bin

# Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# Aliases - Editor
alias v "nvim"
alias vim "nvim"

# Aliases - System
alias c "clear"
alias nf "fastfetch"
alias ff "fastfetch"
alias shutdown "systemctl poweroff"

# Aliases - File management
alias ls "eza -a --tree --level=1 --icons=always --group-directories-first"
alias ll "eza -l --icons=always --no-permissions --no-user --no-time"
alias lt "eza -a --tree --level=1 --icons=always --group-directories-first"

# Aliases - Git
alias gc "git checkout ."
alias gp "git pull"
alias gf "git fetch"
alias gsd "git switch develop"
alias gs "git switch"
alias lg "lazygit"

# Aliases - Rails
alias rc "bin/rails console"
alias rg "rails generate"
alias rs "bin/rails server"

# Aliases - TNT specific
alias tg "/Users/saipr/Documents/tntinfra/scripts/toggle_gems.sh"
alias te "/Users/saipr/Documents/tntinfra/scripts/toggle_env.sh"

# Aliases - tmux
alias ta "tmux attach"
alias tl "tmux list-sessions"
alias tn "tmux new-session -s"
alias ts "$HOME/.config/scripts/tmux-sessionizer.sh"

# Aliases - Fish profile
alias pf "nvim ~/.config/fish/config.fish"
alias pr "source ~/.config/fish/config.fish"

if status is-interactive
    # Tool initializations
    fzf --fish | source
    zoxide init fish | source

    # Use starship 
    starship init fish | source

    # NVM setup
    set -gx NVM_DIR $HOME/.nvm
    if test -s /opt/homebrew/opt/nvm/nvm.sh
        bass source /opt/homebrew/opt/nvm/nvm.sh
    end

    # rbenv
    rbenv init - fish | source

    # envman
    if test -s $HOME/.config/envman/load.sh
        bass source $HOME/.config/envman/load.sh
    end

    # RVM
    if test -s $HOME/.rvm/scripts/rvm
        bass source $HOME/.rvm/scripts/rvm
    end
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/saipr/.lmstudio/bin
# End of LM Studio CLI section

