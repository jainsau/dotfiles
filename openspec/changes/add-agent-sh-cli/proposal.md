## Why

`agent-sh` is useful agent tooling, but installing it with `npm install -g` would bypass the dotfiles' Nix-managed package flow. The Pi backend bridge should also be present without running `agent-sh install pi-bridge`, which would mutate the home directory with npm-managed dependencies.

## What Changes

- Package `guanyilun/agent-sh` with `pkgs.buildNpmPackage`.
- Add the resulting CLI to the existing Home Manager AI tools package list.
- Install the bundled `pi-bridge` extension into `~/.agent-sh/extensions/pi-bridge` from the Nix store.

## Capabilities

### New Capabilities
- `agent-sh-cli`: Home Manager installs the `agent-sh` CLI through Nix and makes the bundled Pi bridge available.

### Modified Capabilities

## Impact

- Affects `nix/home-manager/modules/cli/ai.nix`.
- Adds a generated npm lock file for reproducible dependency fetching.
- Adds a Home Manager-managed symlink for the `pi-bridge` extension.
