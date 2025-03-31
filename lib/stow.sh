#!/usr/bin/env bash

check_stow_installed() {
    if ! command -v stow &> /dev/null; then
        return 1
    fi
    return 0
}

install_stow() {
    echo ">>> Installing Stow..."
    nix-env -iA nixpkgs.stow
    echo ">>> Stow installed."
}

link_with_stow() {
    local config_dir="$1"
    local target_dir="$2"

    if [ ! -d "$config_dir" ]; then
        echo ">>> ERROR: Configuration directory $config_dir does not exist."
        exit 1
    fi

    echo ">>> Linking configuration from $config_dir to $target_dir..."
    mkdir -p "$target_dir"
    stow -R -d "$config_dir" -t "$target_dir" .
    echo ">>> Configuration linked successfully."
}
