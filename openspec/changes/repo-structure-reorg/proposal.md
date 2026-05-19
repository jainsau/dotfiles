# Proposal: Repository Structure Reorganization

## Problem

Several modules are oversized or violate co-location conventions:
- `shell/zsh.nix` conflates core zsh, starship, keybindings, functions
- Shell functions scattered across `fzf.nix:38-80`, `functions.nix:4-12`, `keybindings.nix:4-38`
- `dev/direnv.nix` is a 169-line monolith with 5 hardcoded language layouts
- Empty `vscode/settings.json` and `vscode/keybindings.json` placeholder files

## Proposed Split: shell/zsh.nix

| New File | Contents |
|----------|----------|
| `shell/zsh.nix` | Core zsh options, history, completion, plugins |
| `shell/starship.nix` | Prompt config (extract from zsh.nix) |
| `shell/keybindings.nix` | vi mode, ESC ESC sudo, ZLE widgets (already exists, consolidate) |
| `shell/functions.nix` | Custom shell functions cs, etc. (consolidate from fzf.nix + keybindings.nix) |

## Proposed Split: dev/direnv.nix

Extract per-language stdlib blocks into separate files:
- `dev/direnv/poetry.nix`
- `dev/direnv/rust.nix`
- `dev/direnv/go.nix`
- `dev/direnv/node.nix`

## Cleanup

- Delete `nix/home-manager/editors/vscode/settings.json` (empty)
- Delete `nix/home-manager/editors/vscode/keybindings.json` (empty)
- Extract `cli/fzf.nix` shell functions into `shell/functions.nix`

## Impact

No behavior change. Pure structural refactor.
