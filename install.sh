#!/usr/bin/env bash

set -Eeuo pipefail

# === COLOR DEFINITIONS ===
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# === Install Kitty Terminal ===
install_kitty() {
    if command -v kitty &> /dev/null; then
        echo -e "${GREEN}Kitty is already installed.${NC}"
    else
        echo -e "${BLUE}Installing Kitty...${NC}"
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        echo -e "${GREEN}Kitty installed.${NC}"
    fi
}

# === Install Nix Package Manager ===
install_nix() {
    local daemon_path="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

    if [[ -e "$daemon_path" ]]; then
        echo -e "${GREEN}Nix daemon is already installed.${NC}"
    else
        echo -e "${BLUE}Installing Nix package manager...${NC}"
        curl -L https://nixos.org/nix/install | sh -s -- --daemon
        # Ensure that `nix run` works by enabling flakes and nix-command
        # Create the ~/.config/nix/ directory if it doesn't exist
        mkdir -p "${HOME}/.config/nix"
        echo "experimental-features = nix-command flakes" > ${HOME}/.config/nix/nix.conf
        echo -e "${YELLOW}Please log out and log back in to reload your shell environment.${NC}"
    fi
}

# === Install Zsh ===
install_zsh() {
    if command -v zsh &> /dev/null; then
        echo -e "${GREEN}Zsh is already installed.${NC}"
        return 0
    fi

    echo -e "${BLUE}Installing Zsh...${NC}"
    if [[ "$(uname -s)" == "Darwin" ]]; then
        # macOS ships with zsh; if missing, install via Nix
        nix-env -iA nixpkgs.zsh
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y zsh
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm zsh
    else
        echo -e "${YELLOW}Could not detect package manager. Install zsh manually.${NC}"
        return 1
    fi
    echo -e "${GREEN}Zsh installed.${NC}"
}

# === Set Zsh as Default Shell ===
make_zsh_default() {
    # Check if zsh is available, if not, skip this step
    if ! command -v zsh &> /dev/null; then
        echo -e "${YELLOW}zsh not found. Skipping shell change. You can install zsh later and run this script again.${NC}"
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

    # Create if missing
    if [[ ! -f "$target" ]]; then
        echo -e "${BLUE}Creating $target...${NC}"
        printf '%s\n%s\n' "$marker" "$source_line" > "$target"
        return
    fi

    # Ensure source line is present
    if ! grep -qF "$source_line" "$target"; then
        echo -e "${BLUE}Adding managed sourcing to $target...${NC}"
        printf '\n%s\n%s\n' "$marker" "$source_line" >> "$target"
    else
        echo -e "${GREEN}$target already sources managed config.${NC}"
    fi
}

# === Show Post-Bootstrap Instructions ===
show_post_bootstrap_instructions() {
    local os arch
    os="$(uname -s)"
    arch="$(uname -m)"

    echo -e "${YELLOW}To apply your Nix configuration, run one of the following after restarting your shell:${NC}"

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

# === MAIN BOOTSTRAP SEQUENCE ===
install_kitty
install_nix
install_zsh
make_zsh_default
setup_zsh_sourcing
show_post_bootstrap_instructions

echo -e "${GREEN}Bootstrap process completed successfully.${NC}"
