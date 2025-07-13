# Saurabh's Dotfiles

This repository contains my personal dotfiles, managed with **Nix** and **Home Manager** to create a reproducible, declarative, and highly modular development environment. It is tailored for macOS and includes configurations for Zsh, Neovim, and a wide array of command-line tools.

---

## ✨ Features

- **Declarative & Reproducible**: Built on [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager), ensuring a consistent setup across machines.
- **Fully Modular**: Configurations are broken down into small, single-purpose modules for tools, aliases, and shell settings, making them easy to manage and customize.
- **Modern Shell**: A powerful Zsh environment managed natively with Home Manager, featuring [Starship](https://starship.rs/) for a minimal and fast prompt.
- **Customized Editors**: Tailored configurations for Neovim (based on a streamlined Lua setup) and VSCode.
- **Rich Toolset**: Includes curated configurations for dozens of popular CLI and development tools like `eza`, `bat`, `fzf`, `git`, `delta`, and `lazygit`.
- **Modular config logic** lives in `nix/` (parameterized by settings)
- **Pure flake** (`flake.nix`) with user settings imported from `nix/user.nix` for reproducibility.

---

## 📂 Structure

The configuration is built around a flake-based Nix setup. The core logic resides in the `nix/` directory:

```
dotfiles/
├── flake.nix        # Main Nix Flake entrypoint
├── install.sh       # Installation script
├── prompts/         # AI agent prompts and workflows
└── nix/
    ├── user.nix     # User-specific settings
    ├── mkConfig.nix # Configuration generation logic
    ├── systems.nix  # System definitions (Darwin/Home Manager)
    ├── darwin/      # macOS-specific system configurations
    └── home-manager/  # User-level configurations (managed by Home Manager)
        ├── modules/   # The heart of the setup:
        │   ├── cli/       # CLI tools (e.g., eza, fzf, git, delta, lazygit)
        │   ├── dev/       # Development tools (e.g., direnv, language tools)
        │   ├── shell/     # Zsh, Tmux, and other shell settings
        │   └── system-tools.nix  # System monitoring tools (e.g., podman, nmap)
        └── default.nix  # Aggregates all Home Manager configurations
```

---

## 🚀 Installation & Usage

1.  **Clone the Repository**: 
    ```bash
    git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ```
2.  **Run the Installation Script**: This will install Nix and set up your environment.
    ```bash
    ./install.sh
    ```
3.  **Edit User Settings**: If needed, edit your user-specific settings in `nix/user.nix`.
4.  **Apply Changes**: After editing your configuration, apply the changes with:
    - `nix run .#hma-switch` (for Home Manager)
    - `nix run .#dma-switch` (for Darwin)

---

## 🔧 User Settings

User-specific settings (such as username, home directory, git identity) are defined in `nix/user.nix`. Edit this file to personalize your setup:

```nix
{
  username = "your_username";
  homeDirectory = "/Users/your_username";
  gitUser = "Your Name";
  gitEmail = "your.email@example.com";
}
```

---

## 🤖 AI Agent Prompts

The `prompts/` directory contains prompts for AI agents to help maintain this project.

### Usage Examples

```bash
# Copy prompt content and use with your preferred AI assistant
# Example: prompts/nix/audit.md for package reviews
# Example: prompts/workflows/check.md for module structure audits
```

---

## 🙏 Credits

This project was inspired by the robust and declarative nature of Nix and the broader Nix community.
