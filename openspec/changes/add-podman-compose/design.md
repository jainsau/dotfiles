## Design

Use the smallest split by platform:

- Linux Home Manager installs `pkgs.podman` and `pkgs.podman-compose`.
- Darwin nix-darwin installs Homebrew formulae `podman` and `podman-compose`.

No wrapper scripts or custom packages are added.
