# Proposal: Fix Bugs — Podman Flag + Git Signing Guard

## Problem

Two bugs found in audit:

**Bug 1 — podman.nix uses wrong feature flag**
- File: `nix/home-manager/modules/system/podman.nix:6`
- Current: `mkIf config.tools.enableMonitoring`
- Wrong: Podman only installs when monitoring tools are enabled — incorrect coupling
- Fix: add `enablePodman` option, change condition to `config.tools.enablePodman`

**Bug 2 — git signing always configured even when gpgKey is empty**
- File: `nix/home-manager/modules/cli/git.nix:36-40`
- Current: `programs.git.signing` set unconditionally from `args.gpgKey`
- Wrong: If `gpgKey = ""` in `.user.nix`, git silently misconfigures signing
- Fix: wrap in `lib.mkIf (args.gpgKey != "") { ... }`

## Proposed Changes

1. Add `enablePodman = true` to options in `modules/default.nix`
2. Update `system/podman.nix:6` to use `config.tools.enablePodman`
3. Update `cli/git.nix:36-40` to guard signing block with `gpgKey != ""`

## Impact

- No behavior change for users with `gpgKey` set and monitoring enabled
- Users with `gpgKey = ""` no longer get broken git signing config
- Podman can now be toggled independently of monitoring tools
