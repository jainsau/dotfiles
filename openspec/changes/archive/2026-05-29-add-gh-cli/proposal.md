## Why

The GitHub CLI (`gh`) is currently installed as a generic package in `tools.nix`, but it lacks declarative configuration. This means authentication helpers, default protocol (SSH), and standard aliases are not managed declaratively via Home Manager.

## What Changes

- Remove `gh` from the simple `home.packages` list in `nix/home-manager/modules/cli/tools.nix`.
- Enable and configure `programs.gh` in `nix/home-manager/modules/cli/git.nix`, conditional on `config.tools.enableGit`.
- Configure default protocol to SSH and define standard aliases for a smoother workflow.

## Capabilities

### New Capabilities

- `gh-cli`: Declarative installation, alias configuration, and credential helper setup for the GitHub CLI.

### Modified Capabilities

<!-- None -->

## Impact

- Moves `gh` installation from `tools.nix` to `git.nix` via `programs.gh`.
- Affects Git and GitHub workflows by automating SSH protocol and credential helpers.
