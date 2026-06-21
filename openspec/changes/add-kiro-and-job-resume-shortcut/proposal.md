## Why

The Pi kit manifest should include the installed Kiro provider/login extension so the setup can be reproduced, and the shell should make it easy to recover suspended jobs without remembering job IDs.

## What Changes

- Add the Kiro provider/login Pi package to `kit.yml`.
- Add a Zsh/fzf widget and shortcut for listing suspended/background jobs and resuming the selected job in the foreground.

## Capabilities

### New Capabilities
- `pi-kit`: Reproducible Pi package kit manifest entries.
- `shell-keybindings`: Interactive shell keybindings and ZLE widgets.

### Modified Capabilities

## Impact

- Affects `kit.yml` and `nix/home-manager/modules/shell/keybindings.nix`.
- Requires Home Manager switch and a new shell session to use the new Zsh keybinding.
