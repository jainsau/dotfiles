# Saurabh's Dotfiles

This repository contains my personal dotfiles, managed with **Nix** and **Home Manager** to create a reproducible, declarative, and highly modular development environment. It targets **macOS** (Darwin via nix-darwin and standalone Home Manager) and **Linux** (standalone Home Manager, e.g. `hlx-switch` / `hla-switch`), with Zsh, Neovim, and a wide array of command-line tools.

---

## 📝 Neovim: adding LSPs and linters

Home Manager installs Neovim config from `nix/home-manager/editors/nvim` by copying that directory into the Nix store and linking `~/.config/nvim` to that snapshot (it is not a live symlink to your git checkout).

- Add an LSP server:
  - Edit `nix/home-manager/editors/nvim/lua/plugins/mason.lua` and add the server to the `servers` table.
  - Mason will auto-install servers/tools declared via `ensure_installed` on first launch.

- Add a linter:
  - Edit `nix/home-manager/editors/nvim/lua/plugins/lint.lua` and add the linter to `linters_by_ft`.
  - If the linter is an external CLI (e.g., `markdownlint-cli2`), install it via Nix by adding it to `home.packages` in `nix/home-manager/default.nix`.

- When do you need to switch / rebuild?
  - Editing Lua (or any file under that `nvim` tree): run **Home Manager switch** (e.g. `nix run .#hma-switch` or `nix run .#hlx-switch`), then **restart Neovim** so it loads the new store path.
  - Adding external binaries via Nix: same—Home Manager switch.
  - Updating to newer package versions: run `nix flake update` (or update a specific input), then switch again.

---

## 🐚 Zsh and Homebrew

Zsh init loads **Homebrew** only when a `brew` binary exists: **`/opt/homebrew/bin/brew`** (Apple Silicon default prefix) or **`/usr/local/bin/brew`** (Intel Mac default prefix). On Linux, neither path is used, so no `brew shellenv` runs there. See `nix/home-manager/modules/shell/zsh.nix`.

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
    - **macOS — nix-darwin**: `nix run .#dma-switch` (Apple Silicon) or `nix run .#dmx-switch` (Intel), as appropriate for your machine (`nix/systems.nix`).
    - **macOS — Home Manager only**: `nix run .#hma-switch` or `nix run .#hmx-switch`.
    - **Linux — Home Manager**: `nix run .#hlx-switch` (x86_64) or `nix run .#hla-switch` (aarch64).

---

## 🔄 Updating packages

This repo uses flakes. Switching uses the versions pinned in `flake.lock`.

- To switch with current pins:
  - Darwin: `darwin-rebuild switch --flake .`
  - Home Manager: `home-manager switch --flake .`

- To update to newer package versions:
  - All inputs: `nix flake update`
  - Specific input (e.g., nixpkgs): `nix flake update --update-input nixpkgs`
  - Then run the switch command again.

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

**Home directory on Linux:** Darwin configurations use `homeDirectory` from this file. Linux Home Manager configurations use **`/home/<username>`** as set in `nix/mkConfig.nix` (see `getHomeDirectory`). If your Linux home path or username differs, adjust `nix/user.nix` and/or `nix/mkConfig.nix` / `nix/systems.nix` accordingly.

