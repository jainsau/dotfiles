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

# Main Process
echo ">>> Starting Bootstrap Process..."

# Step 1:
if ! check_nix_installed; then
  install_nix
else
  echo ">>> Nix is already installed."
  update_nix
fi

# Step 2: Install Home Manager
if ! check_home_manager_installed; then
  install_home_manager
else
  echo ">>> Home Manager is already installed."
fi

# Step 3: Apply Home Manager Configuration
ln -s "$SOURCE_CONFIG_DIR/home-manager/home.nix" "$TARGET_CONFIG_DIR/home-manager/home.nix"
apply_home_manager_config

# Step 4: Link config files
link_with_stow "$SOURCE_CONFIG_DIR" "$TARGET_CONFIG_DIR"

# Step 5:
# Add zsh as a login shell
! [[ $(grep zsh /etc/shells) ]] && command -v zsh | sudo tee -a /etc/shells
# use zsh as default shell
sudo chsh -s $(which zsh) $USER

echo ">>> Bootstrap process completed successfully!"
