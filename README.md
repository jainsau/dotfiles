# Saurabh's Dotfiles

This repository contains my personal dotfiles, managed with **Nix** and **Home Manager** to create a reproducible, declarative, and highly modular development environment. It is tailored for macOS and includes configurations for Zsh, Neovim, and a wide array of command-line tools.

---

## ✨ Features

- **Declarative & Reproducible**: Built on [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager), ensuring a consistent setup across machines.
- **Fully Modular**: Configurations are broken down into small, single-purpose modules for tools, aliases, and shell settings, making them easy to manage and customize.
- **Modern Shell**: A powerful Zsh environment managed natively with Home Manager, featuring [Starship](https://starship.rs/) for a minimal and fast prompt.
- **Customized Editors**: Tailored configurations for Neovim (based on a streamlined Lua setup) and VSCode.
- **Rich Toolset**: Includes curated configurations for dozens of popular CLI and development tools like `eza`, `bat`, `fzf`, `git`, `delta`, and `lazygit`.

---

## 📂 Structure

The configuration is built around a flake-based Nix setup. The core logic resides in the `nix/` directory:

```
dotfiles/
├── flake.nix        # Main Nix Flake entrypoint
├── install.sh       # Installation script
├── prompts/         # AI agent prompts and workflows
└── nix/
    ├── darwin/      # macOS-specific system configurations
    └── home-manager/  # User-level configurations (managed by Home Manager)
        ├── modules/   # The heart of the setup:
        │   ├── cli/       # Modules for CLI tools (e.g., eza, fzf)
        │   ├── dev/       # Modules for development tools (e.g., git, direnv)
        │   ├── fun/       # Modules for fun utilities (e.g., cowsay)
        │   ├── shell/     # Zsh, Tmux, and other shell settings
        │   └── system/    # System-related tools (e.g., podman)
        └── default.nix  # Aggregates all Home Manager configurations
```

---

## 🤖 AI Agent Prompts

The `prompts/` directory contains specialized prompts and workflows for AI agents like **opencode** and **Gemini CLI** to help maintain and improve this dotfiles project:

- **`prompts/nix/`** - Nix-specific prompts for package management and troubleshooting
- **`prompts/workflows/`** - Multi-step workflows for common maintenance tasks
- **`prompts/templates/`** - Reusable prompt templates for configuration reviews
- **`prompts/dotfiles/`** - General dotfiles management and migration planning

### Usage Examples

```bash
# Review packages with opencode
opencode -p prompts/nix/audit.md

# Audit module structure with Gemini
gemini -f prompts/workflows/check.md
```

---

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```
*(Replace `your-username` with your actual GitHub username.)*

### 2. Run the Installation Script
The script will automatically install Nix if it's not present on your system, then apply the configuration.
```bash
./install.sh
```

---

## 🛠️ Applying Changes

After making changes to the configuration, you can apply them using the following commands:

- **Apply Home Manager configuration only:**
  ```bash
  nix run .#hma-switch
  ```

- **Apply Darwin system configuration only:**
  ```bash
  nix run .#dma-switch
  ```

---

## 🛠️ Customization

To add, remove, or modify a tool, simply edit the corresponding file in the `nix/home-manager/modules/` subdirectories and re-run the appropriate switch command.

For example, to change the `git` aliases, you would edit `nix/home-manager/modules/dev/git.nix` and then run `nix run .#hma-switch`.

---

## 🙏 Credits

This project was inspired by the robust and declarative nature of Nix and the broader Nix community.

