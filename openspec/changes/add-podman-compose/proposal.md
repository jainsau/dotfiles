## Why

The Podman Home Manager module evaluated the Linux-only nixpkgs `podman` package on macOS, breaking Darwin builds. We also want `podman-compose` available with Podman.

## What Changes

- Install Nix `podman` and `podman-compose` only on Linux.
- Install Homebrew `podman` and `podman-compose` on Darwin.
- Keep the existing `p=podman` shell alias.

## Capabilities

### New Capabilities
- `podman-compose`: Podman Compose is installed alongside Podman on supported platforms.

### Modified Capabilities

## Impact

- Affects `nix/home-manager/modules/system/podman.nix` and `nix/darwin/default.nix`.
- Fixes Darwin evaluation by avoiding unsupported Nix Podman packages there.
