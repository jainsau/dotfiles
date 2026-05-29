## Context

Compilation of source-built python wheels containing C-bindings (like tree-sitter-dm) fails on macOS when standard headers (like assert.h) are not found. We will fix this by setting the SDKROOT environment variable.

## Goals / Non-Goals

**Goals:**
- Dynamically detect macOS inside the Home Manager activation script.
- Set the `SDKROOT` environment variable using `xcrun --show-sdk-path` when macOS is detected.

**Non-Goals:**
- Setting `SDKROOT` on Linux systems.

## Decisions

- **Use bash conditions in activation script `setupGraphify`:** Placing the export command behind a check of `uname` is highly portable and ensures we only run it on Darwin systems.

## Risks / Trade-offs

- **Risk:** `xcrun` or command line tools not being available.
  - **Mitigation:** Nix-darwin handles setting up command-line tools, and if `xcrun` fails, the script will gracefully fallback or ignore.
