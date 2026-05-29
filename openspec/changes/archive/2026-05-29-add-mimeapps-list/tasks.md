## 1. Configure mimeapps.list in home-manager

- [x] 1.1 Add `xdg.configFile."mimeapps.list"` block in `nix/home-manager/default.nix` with `force = true`

## 2. Verify and Apply

- [x] 2.1 Run `nix flake check` to verify configuration syntax
- [x] 2.2 Switch HM config using `nix run --impure .#hma-switch`
- [x] 2.3 Verify `~/.config/mimeapps.list` is created and correctly links to the home-manager store path
