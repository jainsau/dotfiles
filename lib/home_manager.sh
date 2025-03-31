#!/usr/bin/env bash

check_home_manager_installed() {
    if command -v home-manager &> /dev/null; then
        return 0
    fi
    return 1
}

install_home_manager() {
    echo ">>> Installing Home Manager..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    echo ">>> Home Manager installed."
}

apply_home_manager_config() {
    echo ">>> Applying Home Manager configuration..."
    # Drop sudo privileges temporarily
    sudo -u "$SUDO_USER" -- bash <<EOF
home-manager switch
EOF
    echo ">>> Home Manager configuration applied successfully."
}
