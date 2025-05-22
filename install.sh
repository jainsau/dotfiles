#!/usr/bin/env bash

set -Eeuo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="git@github.com:jainsau/dotfiles.git"
REPO_DIR="$HOME/Documents/workspace/dotfiles1"    #TODO ask user input
SOURCE_CONFIG_DIR="$REPO_DIR/config"
TARGET_CONFIG_DIR="$HOME/.config"

is_nix_installed() {
    command -v nix &> /dev/null
}

is_stow_installed() {
    command -v stow &> /dev/null
}

is_kitty_installed() {
    command -v kitty &> /dev/null
}

install_nix() {
    echo -e "${BLUE}Installing Nix package manager...${NC}"
    curl -L https://nixos.org/nix/install | sh -s -- --daemon
    echo -e "${GREEN}Nix installation completed. Please log out and log back in to reload your shell.${NC}"
}

update_nix() {
    echo -e "${BLUE}Updating Nix...${NC}"
    nix-channel --update
    nix-env -f '<nixpkgs>' -u '*'
    echo -e "${GREEN}Nix is updated.${NC}"
}

install_stow() {
    echo -e "${BLUE}Installing GNU Stow...${NC}"
    nix-env -iA nixpkgs.stow
    echo -e "${GREEN}Stow installed.${NC}"
}

link_with_stow() {
    local config_dir="$1"
    local target_dir="$2"

    if [[ ! -d "$config_dir" ]]; then
        echo -e "${RED}Error: Config directory '$config_dir' does not exist.${NC}"
        exit 1
    fi

    echo -e "${BLUE}Linking config from '$config_dir' to '$target_dir'...${NC}"
    mkdir -p "$target_dir"
    stow -R -d "$config_dir" -t "$target_dir" .
    echo -e "${GREEN}Config linked successfully.${NC}"
}

clone_repo_if_needed() {
    if [[ ! -d "$REPO_DIR" ]]; then
        mkdir -p "$(dirname "$REPO_DIR")"
        echo -e "${BLUE}Cloning config repo...${NC}"
        git clone "$REPO_URL" "$REPO_DIR"
        echo -e "${GREEN}Repo cloned to $REPO_DIR${NC}"
    else
        echo -e "${GREEN}Repo already exists at $REPO_DIR${NC}"
    fi
}

run_flake_switches() {
  local os arch darwin_target home_target

  os="$(uname -s)"
  arch="$(uname -m)"

  case "$os" in
    Darwin)
      case "$arch" in
        arm64)
          darwin_target="dma"
          home_target="hma"
          ;;
        x86_64)
          darwin_target="dmx"
          home_target="hmx"
          ;;
        *)
          echo -e "${RED}Unsupported architecture: $arch${NC}"
          exit 1
          ;;
      esac
      echo -e "${BLUE}Running darwin config: $darwin_target-switch${NC}"
      nix run "$REPO_DIR#$darwin_target-switch"

      echo -e "${BLUE}Running home config: $home_target-switch${NC}"
      nix run "$REPO_DIR#$home_target-switch"
      ;;
    Linux)
      case "$arch" in
        aarch64)
          home_target="hla"
          ;;
        x86_64)
          home_target="hlx"
          ;;
        *)
          echo -e "${RED}Unsupported architecture: $arch${NC}"
          exit 1
          ;;
      esac
      echo -e "${BLUE}Running home config: $home_target-switch${NC}"
      nix run "$REPO_DIR#$home_target-switch"
      ;;
    *)
      echo -e "${RED}Unsupported OS: $os${NC}"
      exit 1
      ;;
  esac
}

# Bootstrap process

if is_nix_installed; then
    echo -e "${GREEN}Nix is already installed.${NC}"
    # update_nix
else
    install_nix
fi

if ! is_stow_installed; then
    install_stow
else
    echo -e "${GREEN}GNU Stow is already installed.${NC}"
fi

clone_repo_if_needed

link_with_stow "$SOURCE_CONFIG_DIR" "$TARGET_CONFIG_DIR"

run_flake_switches

# Add zsh to /etc/shells if it's not already there
if ! grep -q "$(command -v zsh)" /etc/shells; then
    echo -e "${BLUE}Adding zsh to /etc/shells...${NC}"
    command -v zsh | sudo tee -a /etc/shells
fi

# Change the user's login shell to zsh
if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo -e "${BLUE}Changing default shell to zsh...${NC}"
    sudo chsh -s "$(command -v zsh)" "$USER"
fi

if ! is_kitty_installed; then
    echo -e "${BLUE}Installing Kitty...${NC}"
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    echo -e "${GREEN}Kitty installed.${NC}"
else
    echo -e "${GREEN}Kitty is already installed.${NC}"
fi

echo -e "${GREEN}Bootstrap process completed.${NC}"
