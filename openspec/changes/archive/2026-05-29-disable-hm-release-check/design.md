## Context

Home Manager triggers a trace warning during deployment if there's a minor mismatch in Home Manager and Nixpkgs release version dates. We want to declaratively disable this check in our configuration.

## Goals / Non-Goals

**Goals:**
- Mute Home Manager version mismatch checks during deployment.

**Non-Goals:**
- Modifying Nixpkgs or Home Manager versions directly.

## Decisions

- **Set `home.enableNixpkgsReleaseCheck = false;` in `nix/home-manager/default.nix`:** This is the native option recommended by Home Manager to mute mismatch trace warnings.

## Risks / Trade-offs

- **Risk:** Missing actual breaking mismatches between Nixpkgs and HM.
  - **Mitigation:** Safe, because we run `nix flake check` to verify syntax and package evaluation errors before deploying.
