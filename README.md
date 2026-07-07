# Dotfiles

Bootstrap a fresh machine with:

```bash
curl -fsSL https://raw.githubusercontent.com/saipr0/dotfiles/main/install.sh -o install.sh
bash install.sh
```

That script will install the base tools, clone or update the dotfiles repo, stow the config, install `mise`, switch your login shell to `zsh`, and install the tools listed in `~/.config/mise/config.toml`.
