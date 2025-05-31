#!/usr/bin/env bash

set -Eeuo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

install_kitty() {
    if command -v kitty &> /dev/null; then
        echo -e "${GREEN}Kitty is already installed.${NC}"
    else
        echo -e "${BLUE}Installing Kitty...${NC}"
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        echo -e "${GREEN}Kitty installed.${NC}"
    fi
}

install_nix() {
    local daemon_path="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

    if [[ -e "$daemon_path" ]]; then
        echo -e "${GREEN}Nix daemon is already installed.${NC}"
    else
        echo -e "${BLUE}Installing Nix package manager...${NC}"
        curl -L https://nixos.org/nix/install | sh -s -- --daemon
        # making sure that `nix run` works
        echo "experimental-features = nix-command flakes" > ${HOME}/.config/nix/nix.conf
        echo -e "${YELLOW}Please log out and log back in to reload your shell environment.${NC}"
    fi
}

make_zsh_default() {
    local zsh_bin
    zsh_bin="$(command -v zsh)"

    if ! grep -q "$zsh_bin" /etc/shells; then
        echo -e "${BLUE}Adding zsh to /etc/shells...${NC}"
        echo "$zsh_bin" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_bin" ]]; then
        echo -e "${BLUE}Changing default shell to zsh...${NC}"
        sudo chsh -s "$zsh_bin" "$USER"
    else
        echo -e "${GREEN}zsh is already the default shell.${NC}"
    fi
}

show_post_bootstrap_instructions() {
    local os arch
    os="$(uname -s)"
    arch="$(uname -m)"

    echo -e "${YELLOW}To apply your Nix configuration, run one of the following after restarting your shell:${NC}"

    case "$os" in
        Darwin)
            case "$arch" in
                arm64)
                    echo -e "${BLUE}  nix run .#dma-switch${NC}"
                    echo -e "${BLUE}  nix run .#hma-switch${NC}"
                    ;;
                x86_64)
                    echo -e "${BLUE}  nix run .#dmx-switch${NC}"
                    echo -e "${BLUE}  nix run .#hmx-switch${NC}"
                    ;;
            esac
            ;;
        Linux)
            case "$arch" in
                aarch64)
                    echo -e "${BLUE}  nix run .#hla-switch${NC}"
                    ;;
                x86_64)
                    echo -e "${BLUE}  nix run .#hlx-switch${NC}"
                    ;;
            esac
            ;;
    esac
}

# --- Run the steps ---
install_kitty
install_nix
make_zsh_default
show_post_bootstrap_instructions

echo -e "${GREEN}Bootstrap process completed successfully.${NC}"
