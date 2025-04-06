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

    # Create target dir if it does not exist
    mkdir -p "$2/home-manager"

    # Create symlink only if none exists
    if [[ ! -L $target ]]; then
        echo "⚠️ $target is not a symlink. Removing so we can link our own structure."
        rm -f "$target"
        echo "📎 Creating temporary symlink: $source → $target"
        ln -s "$source" "$target"
    fi

    # Apply Home Manager config
    echo "🚀 Applying Home Manager configuration..."
    home-manager switch
    echo "✅ Configuration applied successfully."

    # Remove symlink if it was created here
    echo "🧹 Cleaning up temporary symlink: $target"
    [[ -L $target ]] && rm -f "$target"
}
