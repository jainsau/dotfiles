#!/usr/bin/env bash

source "$SCRIPT_DIR/lib/utils.sh"

is_nix_installed() {
    command -v nix &> /dev/null
}

install_nix() {
    echo ">>> Installing Nix Package Manager..."

    if ! is_curl_installed; then
        echo "❌ curl is required but not found." >&2
        return 1
    fi

    curl -L https://nixos.org/nix/install | sudo sh -s -- --daemon

    echo "✅ Nix installation completed. Please log out and log back in to reload your shell environment."
}

update_nix() {
    echo "🔄 Updating Nix Package Manager..."

    nix-channel --update
    nix-env -f '<nixpkgs>' -u '*'

    echo "✅ Nix is updated."
}
