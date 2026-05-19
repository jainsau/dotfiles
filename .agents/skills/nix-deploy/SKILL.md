# Nix Deploy

Use this skill when the user asks to "apply changes", "run switch", "deploy", or switch their Nix/Home Manager configuration.

## Pre-flight Checks
1. Check if the git tree is dirty by running `git status --porcelain`.
2. If the tree is dirty, you MUST stage the changes and create a backup commit to prevent switch errors. 
   Run: `git add . && git commit -m "chore: auto-commit before switch"`
3. Before applying, run `nix flake check` to ensure there are no syntax or evaluation errors in the Nix configuration.

## Deployment Logic
1. Detect the operating system and architecture by running `uname -sm`.
2. Based on the output, select the correct switch command:
   - `Darwin arm64` (Apple Silicon macOS): Run `nix run --impure .#dma-switch` (for full system) or `nix run --impure .#hma-switch` (for Home Manager only).
   - `Darwin x86_64` (Intel macOS): Run `nix run --impure .#dmx-switch` (for full system) or `nix run --impure .#hmx-switch` (for Home Manager only).
   - `Linux aarch64` (ARM Linux): Run `nix run --impure .#hla-switch`.
   - `Linux x86_64` (Intel/AMD Linux): Run `nix run --impure .#hlx-switch`.

## Error Handling
1. If the switch fails because an existing file "would be clobbered" (e.g., a manual file conflict), back up the conflicting file (e.g., `mv <file> <file>.backup`) and retry the switch command.
2. If the switch fails due to a Nix syntax error, analyze the error output, fix the corresponding `.nix` file, and retry the deployment from the beginning (starting with `nix flake check`).