#!/usr/bin/env bash
# Bootstrap a fresh machine/container with saipr0/dotfiles + mise.
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/workspace/saipr0}"
DOTFILES_DIR="$WORKSPACE_DIR/dotfiles"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/saipr0/dotfiles.git}"
STOW_PACKAGES=(nvim zsh mise herdr)

log() {
  printf '==> %s\n' "$*"
}

append_once() {
  local file="$1"
  local line="$2"

  mkdir -p "$(dirname "$file")"
  touch "$file"
  grep -qxF "$line" "$file" 2>/dev/null || printf '%s\n' "$line" >>"$file"
}

install_packages() {
  case "$1" in
    apt)
      sudo apt-get update -y
      sudo apt-get install -y git stow curl zsh
      ;;
    pacman)
      sudo pacman -Sy --noconfirm git stow curl zsh
      ;;
    brew)
      brew install git stow curl zsh
      ;;
  esac
}

log "Detecting package manager"
if command -v apt-get >/dev/null 2>&1; then
  PM="apt"
elif command -v pacman >/dev/null 2>&1; then
  PM="pacman"
elif command -v brew >/dev/null 2>&1; then
  PM="brew"
else
  echo "No supported package manager found (apt/pacman/brew). Install git, stow, curl, and zsh manually." >&2
  exit 1
fi

log "Installing OS-level essentials"
install_packages "$PM"

log "Setting up workspace"
mkdir -p "$WORKSPACE_DIR"

log "Cloning or updating dotfiles"
if [ -d "$DOTFILES_DIR/.git" ]; then
  git -C "$DOTFILES_DIR" pull --ff-only
else
  rm -rf "$DOTFILES_DIR"
  git clone --depth 1 "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

log "Stowing packages: ${STOW_PACKAGES[*]}"
cd "$DOTFILES_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    stow -v -t "$HOME" "$pkg"
  else
    log "Skipping $pkg (not present yet)"
  fi
done

log "Installing mise"
curl -fsSL https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

MISE_BIN="$HOME/.local/bin/mise"
if [ ! -x "$MISE_BIN" ]; then
  echo "mise was not installed at $MISE_BIN" >&2
  exit 1
fi

log "Wiring mise into shells"
append_once "$HOME/.bashrc" 'eval "$($HOME/.local/bin/mise activate bash)"'
append_once "$HOME/.zshrc" 'eval "$($HOME/.local/bin/mise activate zsh)"'

log "Installing mise-managed tools"
"$MISE_BIN" trust -a || true
"$MISE_BIN" install

log "Done. Open a new shell, or run: exec \$SHELL -l"
