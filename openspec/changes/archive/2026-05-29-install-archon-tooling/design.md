## Context

We want to install the `archon` CLI and its `pi-archon` plugin declaratively using the existing managers in our repository (Nix-darwin for macOS system binaries, and `kit.yml` for Pi extensions).

## Goals / Non-Goals

**Goals:**
- Install the `archon` CLI on macOS using Nix-darwin's Homebrew integration.
- Install the `pi-archon` extension using `kit.yml` (the repo's declarative source of truth for Pi packages).

**Non-Goals:**
- Manual imperative installation of packages or plugins.

## Decisions

- **Nix-darwin Homebrew Integration for the `archon` CLI:** Since the `archon` CLI is not packaged in upstream `nixpkgs`, we'll declare its tap (`coleam00/archon`) and formula (`archon`) under the `homebrew` settings in `nix/darwin/default.nix`.
- **`kit.yml` for the `pi-archon` plugin:** Since Pi extensions in this repo are managed declaratively using `kit.yml` (and reconciled via `pi-depo`), adding it here keeps the Pi environment fully reproducible.

## Risks / Trade-offs

- **Risk:** Homebrew network availability or build issues.
  - **Mitigation:** Sourced from the official tap `coleam00/archon` which is continuously built.
