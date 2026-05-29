## Why

Existing user configurations of default MIME applications (`mimeapps.list`) can block or trigger "would be clobbered" errors during declarative Home Manager activations. Managing a declarative `mimeapps.list` in Home Manager with `force = true` ensures it always safely overwrites existing user configurations.

## What Changes

- Add `xdg.configFile."mimeapps.list"` with `force = true` to `nix/home-manager/default.nix`.

## Capabilities

### New Capabilities

- `declarative-mimeapps`: Managing and forcefully overwriting MIME application defaults via `xdg.configFile."mimeapps.list"`.

### Modified Capabilities

<!-- None -->

## Impact

- Overwrites existing `~/.config/mimeapps.list` files upon activation.
