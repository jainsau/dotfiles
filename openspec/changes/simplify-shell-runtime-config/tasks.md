## 1. Shell simplification

- [x] 1.1 Replace defensive Home Manager-managed shell fallbacks with direct `XDG_*`/`EDITOR` usage.
- [x] 1.2 Use zsh `[[ ... ]]` conditionals in zsh-only snippets.
- [x] 1.3 Add an fzf alias/function picker widget.
- [x] 1.4 Vendor manydots navigation locally and remove hardcoded dot aliases.
- [x] 1.5 Use the configured login shell for tmux popup shells.

## 2. Runtime surface reduction

- [x] 2.1 Remove CLIProxy module import, enablement, scripts, and services.
- [x] 2.2 Simplify direnv layouts to avoid auto-installing dependencies or starting services.
- [x] 2.3 Remove OpenClaw wrapper and managed OpenClaw config.
- [x] 2.4 Replace remaining dynamic `npx` usage with Nix-built or removed integrations.
- [x] 2.5 Remove graphify auto-install/update activation side effect.

## 3. Validation

- [x] 3.1 Run Home Manager activation package build.
- [x] 3.2 Run `nix flake check`.
- [x] 3.3 Validate relevant OpenSpec changes.
