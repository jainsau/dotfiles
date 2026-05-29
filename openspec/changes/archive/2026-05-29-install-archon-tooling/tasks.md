## 1. Configure Archon in nix-darwin

- [x] 1.1 Add `coleam00/archon` to `taps` and `archon` to `brews` in `nix/darwin/default.nix`

## 2. Configure pi-archon in kit.yml

- [x] 2.1 Add `pi-archon` to `kit.yml` with source `git:github.com/loopyd/pi-archon`

## 3. Verify and Apply

- [x] 3.1 Run `nix flake check` to verify configuration syntax
- [x] 3.2 Verify that `pi-archon` is added to `kit.yml` and parses correctly
