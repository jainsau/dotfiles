## Why

Archon and its Pi agent plugin are not currently installed. Installing them declaratively allows us to run structured coding workflows, use multi-agent team orchestration, and integrate verification loops directly in our dotfiles and Pi sessions.

## What Changes

- Add the `coleam00/archon` tap and the `archon` formula to the Homebrew configuration inside `nix/darwin/default.nix`.
- Add the `pi-archon` plugin to `kit.yml` to declaratively install the Pi agent extension.

## Capabilities

### New Capabilities

- `archon-tooling`: Declarative installation of the Archon orchestrator CLI and the `pi-archon` slash-command integration.

### Modified Capabilities

<!-- None -->

## Impact

- Adds the `archon` executable to macOS.
- Registers the `/archon` slash-command in Pi sessions.
