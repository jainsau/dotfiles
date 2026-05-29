## Why

During Home Manager activations, a trace warning is displayed regarding mismatched versions between Home Manager (26.05) and Nixpkgs (26.11). Disabling this check silences the trace warning and keeps the terminal output clean.

## What Changes

- Add `home.enableNixpkgsReleaseCheck = false;` to `nix/home-manager/default.nix`.

## Capabilities

### New Capabilities

- `disable-hm-version-check`: Mute Home Manager version release mismatch warnings during activation.

### Modified Capabilities

<!-- None -->

## Impact

- Prevents version mismatch trace warnings on Home Manager switch/activation.
