# Proposal: CI/CD Pipeline with GitHub Actions

## Problem

No automated validation of config changes. Broken flake only discovered at `darwin-rebuild switch` time. No automated dependency updates.

## Proposed Workflows

### 1. flake-check.yml — PR validation
- Trigger: push / PR to master
- Steps: `nix flake check`, `nix build .#darwinConfigurations.*.system` (dry-run)
- Uses stub `.user.nix` with empty strings for secrets

### 2. nix-flake-update.yml — automated updates
- Trigger: weekly cron (Monday 09:00)
- Steps: `nix flake update`, create PR with diff
- Allows review before merge

### 3. test.yml — bootstrap smoke test (optional/future)
- Trigger: manual dispatch
- Steps: launch macOS/Linux VM, run `install.sh`, verify home-manager activates

## Files to Create

- `.github/workflows/flake-check.yml`
- `.github/workflows/nix-flake-update.yml`
- `.github/nix/stub-user.nix` — stub user config for CI

## Impact

- Requires GitHub repo (public or private)
- macOS runners available on GitHub Actions (cost: billed minutes)
- Linux flake check can run on free ubuntu runners
