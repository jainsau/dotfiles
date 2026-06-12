## Why

Apple's `container` CLI provides the native macOS container runtime path for Apple Silicon Macs. Adding it to the declarative Darwin configuration makes the tool available consistently without manual Homebrew installs.

## What Changes

- Add the Homebrew `container` formula to the macOS Darwin configuration.
- Gate the formula to Apple Silicon Darwin systems because Apple's Container CLI is Apple Silicon-only.
- Leave Linux and Home Manager-only configurations unchanged.

## Capabilities

### New Capabilities
- `apple-container-cli`: Declarative installation of Apple's Container CLI on supported macOS systems.

### Modified Capabilities
- None.

## Impact

- Affected code: `nix/darwin/default.nix`.
- Affected systems: Apple Silicon nix-darwin configurations.
- Dependencies: Homebrew formula `container`.
