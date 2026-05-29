## Why

During Home Manager activation, the `setupGraphify` hook compiles `tree-sitter-dm` (a dependency of `graphifyy`) from source on macOS. This fails with `fatal error: 'assert.h' file not found` because the compiler cannot locate standard system headers unless the macOS SDK root path is explicitly exported in the environment.

## What Changes

- Modify the `setupGraphify` activation hook inside `nix/home-manager/modules/cli/ai.nix` to detect macOS and dynamically export the correct `SDKROOT` using `xcrun --show-sdk-path`.

## Capabilities

### New Capabilities

- `graphify-compilation-fix`: Automated resolution of macOS compiler SDK paths for compiling Graphify and tree-sitter packages.

### Modified Capabilities

<!-- None -->

## Impact

- Resolves compilation and activation failure on macOS Darwin systems.
