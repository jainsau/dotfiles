## Why

Postman is not currently installed as part of the declarative dotfiles configuration. Adding it via Homebrew casks ensures a reproducible development environment for API development and testing on macOS.

## What Changes

- Add the `postman` cask to the `homebrew.casks` list inside `nix/darwin/default.nix`.

## Capabilities

### New Capabilities

- `postman-api-tool`: Declarative installation of Postman on macOS systems using nix-darwin's homebrew integration.

### Modified Capabilities

<!-- None -->

## Impact

- Adds the Postman GUI application to systems running the macOS configuration.
