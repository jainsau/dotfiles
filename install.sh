#!/usr/bin/env bash

set -Eeuo pipefail

# === COLOR DEFINITIONS ===
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# === Phase Detection ===
nix_available() {
    [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]
}

# =============================================================================
# PHASE 1: Pre-Nix — install Nix itself
# =============================================================================

install_nix() {
    if nix_available; then
        echo -e "${GREEN}Nix is already installed.${NC}"
    else
        echo -e "${BLUE}Installing Nix package manager...${NC}"
        curl -L https://nixos.org/nix/install | sh -s -- --daemon
        mkdir -p "${HOME}/.config/nix"
        echo "experimental-features = nix-command flakes" > "${HOME}/.config/nix/nix.conf"
        echo -e "${GREEN}Nix installed.${NC}"
        echo -e "${YELLOW}Please restart your shell and run this script again to continue setup.${NC}"
        exit 0
    fi
}

# =============================================================================
# PHASE 2: Post-Nix — everything else, using Nix
# =============================================================================

# === Set Zsh as Default Shell ===
# Zsh is installed by Home Manager (programs.zsh.enable = true).
# This just ensures it's the login shell.
make_zsh_default() {
    if ! command -v zsh &> /dev/null; then
        echo -e "${YELLOW}zsh not found. Run your Home Manager switch first, then re-run this script.${NC}"
        return 0
    fi

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

# === Setup Zsh Sourcing ===
# Keep ~/.zshrc mutable so external tools can modify it.
# Home Manager writes managed config to ~/.config/zsh/.zshrc; we source it from ~/.zshrc.
setup_zsh_sourcing() {
    local target="$HOME/.zshrc"
    local managed="$HOME/.config/zsh/.zshrc"
    local source_line="[[ -f \"$managed\" ]] && source \"$managed\""
    local marker="# --- managed config (do not remove) ---"

    # Reclaim ~/.zshenv if HM owns it (removes ZDOTDIR redirect)
    if [[ -L "$HOME/.zshenv" ]] && [[ "$(readlink "$HOME/.zshenv")" == /nix/store/* ]]; then
        echo -e "${BLUE}Reclaiming ~/.zshenv from Home Manager...${NC}"
        rm "$HOME/.zshenv"
    fi

    if [[ ! -f "$target" ]]; then
        echo -e "${BLUE}Creating $target...${NC}"
        printf '%s\n%s\n' "$marker" "$source_line" > "$target"
        return
    fi

    if ! grep -qF "$source_line" "$target"; then
        echo -e "${BLUE}Adding managed sourcing to $target...${NC}"
        printf '\n%s\n%s\n' "$marker" "$source_line" >> "$target"
    else
        echo -e "${GREEN}$target already sources managed config.${NC}"
    fi
}

# === Show Switch Instructions ===
show_switch_instructions() {
    local os arch
    os="$(uname -s)"
    arch="$(uname -m)"

    echo -e "${YELLOW}To apply your Nix configuration, run:${NC}"

    case "$os" in
        Darwin)
            case "$arch" in
                arm64)
                    echo -e "${BLUE}  nix run --impure .#dma-switch${NC}"
                    echo -e "${BLUE}  nix run --impure .#hma-switch${NC}"
                    ;;
                x86_64)
                    echo -e "${BLUE}  nix run --impure .#dmx-switch${NC}"
                    echo -e "${BLUE}  nix run --impure .#hmx-switch${NC}"
                    ;;
            esac
            ;;
        Linux)
            case "$arch" in
                aarch64)
                    echo -e "${BLUE}  nix run --impure .#hla-switch${NC}"
                    ;;
                x86_64)
                    echo -e "${BLUE}  nix run --impure .#hlx-switch${NC}"
                    ;;
            esac
            ;;
    esac
}

# =============================================================================
# MAIN
# =============================================================================

echo -e "${BLUE}=== Dotfiles Bootstrap ===${NC}"

# Phase 1: Install Nix (exits if freshly installed, asking for shell restart)
install_nix

# Phase 2: Everything else (only runs once Nix is available)
echo -e "${BLUE}Nix is available. Running post-Nix setup...${NC}"
make_zsh_default
setup_zsh_sourcing
show_switch_instructions

echo -e "${GREEN}Bootstrap complete.${NC}"
