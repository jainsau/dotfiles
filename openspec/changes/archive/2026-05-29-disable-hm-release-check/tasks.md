## 1. Disable Nixpkgs Release Check

- [x] 1.1 Add `home.enableNixpkgsReleaseCheck = false;` to `nix/home-manager/default.nix`

## 2. Verify and Apply

- [x] 2.1 Run `nix flake check` to verify configuration syntax
- [x] 2.2 Switch HM config and verify mismatch trace warning is muted
