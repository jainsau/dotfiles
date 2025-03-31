#!/usr/bin/env bash

check_nix_installed() {
    if ! command -v nix &> /dev/null; then
        return 1
    fi
    return 0
}

install_nix() {
    echo ">>> Installing Nix Package Manager..."
    if ! has_sudo_privileges; then
        echo "Insufficient privileges. Sudo access required."
        exit 1
    fi
    if ! is_curl_installed; then
        echo "curl is required."
        return 1
    fi
    curl -L https://nixos.org/nix/install | sudo sh -s -- --daemon
    echo ">>> Nix installation completed. Please log out and log back in to reload your shell environment."
}

update_nix() {
    echo ">>> Updating Nix Package Manager..."
    # Drop sudo privileges temporarily
    sudo -u "$SUDO_USER" -- bash <<EOF
nix-channel --update
nix-env -f '<nixpkgs>' -u '*'
EOF
    echo ">>> Nix is updated."
}
