# TODO

## Planned Features

- [ ] macOS system configuration with nix-darwin
- [ ] Secret management with sops-nix or agenix
- [ ] CI/CD pipeline with GitHub Actions
- [ ] Advanced direnv setups
- [ ] Nix overlays for package customization

## Bootstrap Refactor

- [ ] Split `install.sh` into two phases:
  - **Phase 1 (pre-Nix)**: Install Nix only
  - **Phase 2 (post-Nix)**: zsh install (via Nix), `chsh`, zsh sourcing setup, switch instructions
- [ ] Remove `install_zsh` system package manager logic — let Nix/Home Manager handle zsh installation
- [ ] Add a `--phase` flag or auto-detect which phase to run based on whether Nix is available

## Linux Subsystem (`nix/linux/`)

Create a Linux system management layer analogous to `nix/darwin/` for macOS:

- [ ] Add `nix/linux/default.nix` — top-level Linux system config module
- [ ] Add `linux` type to `nix/systems.nix` (e.g. `lla`, `llx`) alongside existing `darwin` and `home` types
- [ ] Add `mkLinuxConfig` to `nix/mkConfig.nix` — generate Linux system configs (could wrap NixOS or manage system-level concerns via scripts/systemd units)
- [ ] Handle system-level package management (apt/dnf/pacman) declaratively, similar to how darwin uses Homebrew
- [ ] Linux-specific system services (systemd units managed at system level vs Home Manager user level)
- [ ] Linux-specific system settings (sysctl, kernel params, firewall rules)
- [ ] Generate `lxx-switch` / `lxa-switch` helper scripts for Linux system configs

## Repo Structure Reorganization

Split oversized modules and establish clear conventions:

- [ ] Break up `shell/zsh.nix` into:
  - `zsh.nix` — core zsh settings (options, history, completion, plugins)
  - `starship.nix` — prompt config
  - `keybindings.nix` — vi mode, ESC ESC sudo, custom ZLE widgets
  - `functions.nix` — custom shell functions (cs, etc.)
- [ ] Extract `kubernetes.nix` from `dev/tools.nix` and `zsh.nix` (kubectl, k9s, completions, alias k)
- [ ] Move `system-tools.nix` into `system/` subdirectory, split into `monitoring.nix` and `network.nix`
- [ ] Clean up `dev/tools.nix` — separate build tools from unrelated utilities

Convention for aliases, functions, keybindings:

| What                      | Where                          | Rule                                    |
|---------------------------|--------------------------------|-----------------------------------------|
| Package + its aliases     | Same module as the tool        | Co-locate with the tool                 |
| Shell functions           | `shell/functions.nix`          | Unless tightly coupled to a specific tool |
| Keybindings / ZLE widgets | `shell/keybindings.nix`        | All input handling in one place         |
| Tool completions + alias  | With the tool module           | Completion depends on the binary        |
| Platform conditionals     | Inline `lib.optionals`         | Keep close to the package               |
| General session vars      | `default.nix`                  | Cross-cutting concerns only             |

## Feature Flags for Optional Tooling

Extend the `editors.enableX` pattern to all tool categories so users can toggle what gets installed:

- [ ] Declare `tools` options in `modules/default.nix` (or a dedicated `options.nix`):
  - `enableTmux` / `enableZellij` (mutually exclusive terminal multiplexers)
  - `enableKubernetes` (kubectl, k9s, completions)
  - `enableNetworkTools` (nmap, mtr, trippy, etc.)
  - `enablePodman`
  - `enableAiTools` (kiro-cli, claude-code, gemini-cli, etc.)
- [ ] Wrap each module's `config` block in `mkIf config.tools.enableX`
- [ ] Set sensible defaults (most things enabled) so existing behavior doesn't change
- [ ] Allow overrides via `.user.nix` for per-machine preferences

## Go CLI Wrapper

Replace `install.sh` and switch scripts with a Go CLI (`dotfiles` or similar):

- [ ] Phase 1 bootstrap: install Nix, install zsh, set default shell, wire zsh sourcing
- [ ] Phase 2 post-Nix: run Home Manager/darwin switch with correct flags
- [ ] Unified `dotfiles apply` command that detects OS/arch and runs the right switch
- [ ] Interactive TUI for feature flag selection (pick tools to enable, writes to `.user.nix`)
- [ ] Better error handling and cross-platform logic than bash
- [ ] Keep Nix for declarative config + packages; Go handles imperative glue and UX