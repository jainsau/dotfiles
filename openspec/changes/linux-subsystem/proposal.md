# Proposal: Linux System Config Subsystem

## Problem

Only `nix/darwin/default.nix` exists for system-level config. Linux machines get Home Manager only — no system-level package management, no systemd units, no kernel/sysctl config.

## Proposed Structure

```
nix/linux/
  default.nix       — top-level Linux system config module
  packages.nix      — system-level packages (analogous to darwin homebrew)
  services.nix      — systemd units
  system.nix        — sysctl, kernel params, firewall
```

### nix/systems.nix additions
Add `linux` type alongside existing `darwin` and `home`:
- `lla` — linux laptop aarch64
- `llx` — linux laptop x86_64
- `lda` — linux desktop aarch64
- `ldx` — linux desktop x86_64

### nix/mkConfig.nix additions
Add `mkLinuxConfig` — generates Linux system configs. Two approaches:
1. **NixOS** — full declarative system (if target is NixOS)
2. **Scripted** — manage system-level concerns via systemd user units + scripts (if target is Ubuntu/Debian/etc.)

### Switch scripts
Generate `lla-switch`, `llx-switch` helper scripts analogous to `dma-switch`, `dmx-switch`.

## Decision Required

NixOS vs. non-NixOS Linux targets? Determines `mkLinuxConfig` implementation significantly.
- NixOS: use `nixosConfigurations` in flake
- Non-NixOS: home-manager standalone + system script layer

## Impact

- New flake outputs for linux configs
- No changes to existing darwin/hm configs
