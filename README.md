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
- **Template + local override**: committed defaults live in `nix/user.nix`, while an optional local `.user.nix` can override them for personal machine-specific values.

---

## 📂 Structure

The configuration is built around a flake-based Nix setup. The core logic resides in the `nix/` directory:

```
dotfiles/
├── flake.nix        # Main Nix Flake entrypoint
├── install.sh       # Installation script
├── .user.nix        # Optional local override (gitignored)
├── prompts/         # AI agent prompts and workflows
└── nix/
    ├── user.nix     # Committed template/default user settings
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
3.  **Set Your Local User Settings**: Keep the committed template in `nix/user.nix` generic. Put your real identity in a local `.user.nix` at the repo root:
    ```nix
    {
      username = "your_username";
      homeDirectory = "/Users/your_username";
      gitUser = "Your Name";
      gitEmail = "your.email@example.com";
    }
    ```
4.  **Apply Changes**: After editing your configuration, apply the changes with:
    - **macOS — nix-darwin**: `nix run --impure .#dma-switch` (Apple Silicon) or `nix run --impure .#dmx-switch` (Intel), as appropriate for your machine (`nix/systems.nix`).
    - **macOS — Home Manager only**: `nix run --impure .#hma-switch` or `nix run --impure .#hmx-switch`.
    - **Linux — Home Manager**: `nix run --impure .#hlx-switch` (x86_64) or `nix run --impure .#hla-switch` (aarch64).

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

This repo keeps personal identity out of git by separating committed defaults from local overrides:

- `nix/user.nix` is the committed template with generic values.
- `.user.nix` is an optional local override file at the repo root. It is ignored by git and should hold your real username, home directory, and git identity.

The override is loaded only during impure evaluation, so use `nix run --impure ...` when switching.

Committed template example in `nix/user.nix`:

```nix
{
  username = "jane";
  homeDirectory = "/Users/jane";
  gitUser = "Jane Doe";
  gitEmail = "jane.doe@acme.example";
}
```

Local override example in `.user.nix`:

```nix
{
  username = "your_username";
  homeDirectory = "/Users/your_username";
  gitUser = "Your Name";
  gitEmail = "your.email@example.com";
}
```

You can also point to a different local override file by setting `DOTFILES_USER_CONFIG` to an absolute path before running the switch command.
