## Why

New repositories created from this dotfiles-managed Git configuration should use the modern default branch name `main` instead of Git's historical `master` default.

## What Changes

- Configure Git's `init.defaultBranch` setting to `main` through Home Manager.
- Ensure `git init` creates repositories with `main` as the initial branch.

## Capabilities

### New Capabilities
- `git-config`: Git client configuration managed by the dotfiles Home Manager module.

### Modified Capabilities

## Impact

- Affects `nix/home-manager/modules/cli/git.nix`.
- No new dependencies or breaking changes.
