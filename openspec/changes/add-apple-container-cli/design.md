## Context

The Apple Container CLI is distributed through the Homebrew formula named `container`. It targets Apple Silicon Macs and is not a cross-platform Home Manager package.

## Decisions

- Install through nix-darwin's Homebrew integration rather than `home.packages` because the tool is not available in the pinned nixpkgs package set.
- Add it to `homebrew.brews` only when `pkgs.stdenv.hostPlatform.isAarch64` is true to avoid attempting installation on Intel Darwin or Linux hosts.
- Do not add aliases or shell hooks; the formula provides the `container` executable directly.

## Risks

- The Homebrew formula has host OS and Xcode requirements that may be stricter than Nix evaluation can detect.
- Homebrew availability and formula metadata are external to Nix's store-level reproducibility.

## Validation

- Run `nix flake check` to verify Nix evaluation.
- On an Apple Silicon Mac with supported macOS/Xcode, run the Darwin switch and verify `container --version`.
