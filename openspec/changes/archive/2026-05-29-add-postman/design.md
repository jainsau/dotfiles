## Context

Postman is a popular GUI tool for API design and testing. Since we manage macOS GUI applications using Nix-darwin's Homebrew cask integration, we will add Postman as a cask.

## Goals / Non-Goals

**Goals:**
- Declaratively install Postman on macOS systems.

**Non-Goals:**
- Install Postman on Linux systems, where users can manage it separately or through standard package managers.

## Decisions

- **Add "postman" to `homebrew.casks` in `nix/darwin/default.nix`:** This is the standard pattern for GUI apps on macOS in this repository.

## Risks / Trade-offs

- **Risk:** Installing GUI apps via Homebrew casks bypasses the Nix sandbox, but is standard and required for proprietary macOS applications.
  - **Mitigation:** Safe since Postman is verified and sourced from the official Homebrew repository.
