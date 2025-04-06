#!/usr/bin/env bash

is_home_manager_installed() {
    command -v home-manager &> /dev/null
}

install_home_manager() {
    echo "📦 Installing Home Manager..."

    # Add the Home Manager channel
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    # Update all channels
    nix-channel --update
    # Install Home Manager
    nix-shell '<home-manager>' -A install

    echo "✅ Home Manager installed successfully."
}

apply_home_manager_config() {
    local source="$1/home-manager/home.nix"
    local target="$2/home-manager/home.nix"

    echo "🔗 Checking for existing config at $target"

    # Create symlink only if none exists
    if [[ ! -L $target && ! -f $target ]]; then
        echo "📎 Creating temporary symlink: $source → $target"
        ln -s "$source" "$target"
    fi

    # Apply Home Manager config
    echo "🚀 Applying Home Manager configuration..."
    if home-manager switch; then
        echo "✅ Configuration applied successfully."
    else
        echo "❌ Failed to apply configuration." >&2
    fi

    # Remove symlink if it was created here
    echo "🧹 Cleaning up temporary symlink: $target"
    rm -f "$target"
}
