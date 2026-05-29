## 1. Fix graphify Activation Hook

- [x] 1.1 Update `setupGraphify` activation script in `nix/home-manager/modules/cli/ai.nix` with dynamic `SDKROOT` export on Darwin

## 2. Verify and Apply

- [x] 2.1 Run `nix flake check` to verify configuration syntax
- [x] 2.2 Switch HM config and verify compilation of tree-sitter-dm succeeds without error
