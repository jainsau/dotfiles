## 1. Clean up tools.nix

- [x] 1.1 Remove `gh` package from `nix/home-manager/modules/cli/tools.nix`

## 2. Configure gh in git.nix

- [x] 2.1 Enable and configure `programs.gh` inside `nix/home-manager/modules/cli/git.nix` with SSH as default protocol

## 3. Apply and Verify

- [x] 3.1 Run `nix flake check` to verify configuration syntax and logic
- [x] 3.2 Apply home-manager / darwin settings using the switch command
- [x] 3.3 Verify that `gh` is successfully installed and configured
