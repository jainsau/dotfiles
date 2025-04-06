#!/usr/bin/env bash

set -Eeuo pipefail

# Define Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_CONFIG_DIR="$SCRIPT_DIR/config"
TARGET_CONFIG_DIR="$HOME/.config"

# Load utility modules
source "$SCRIPT_DIR/lib/nix.sh"
source "$SCRIPT_DIR/lib/stow.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/home_manager.sh"

echo "🚀 Starting Bootstrap Process..."

# Step 1:
if is_nix_installed; then
  echo "✅ Nix is already installed."
  update_nix
else
  install_nix
fi

# Step 2: Install Home Manager
if is_home_manager_installed; then
  echo "✅ Home Manager is already installed."
else
  install_home_manager
fi

# Step 3: Apply Home Manager Configuration
apply_home_manager_config "$SOURCE_CONFIG_DIR" "$TARGET_CONFIG_DIR"

# Step 4: Link config files
link_with_stow "$SOURCE_CONFIG_DIR" "$TARGET_CONFIG_DIR"

# Step 5: Add zsh as a login shell
! grep -q zsh /etc/shells && command -v zsh | sudo tee -a /etc/shells

# Step 6: Use zsh as default shell
sudo chsh -s $(which zsh) $USER

# Step 7: Install Kitty
if ! is_kitty_installed; then
  echo "📦 Installing Kitty..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
  echo "✅ Kitty is already installed."
fi

echo "✅ Bootstrap process completed successfully!"
