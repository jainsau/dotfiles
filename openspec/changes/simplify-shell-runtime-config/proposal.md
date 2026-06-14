## Why

The shell/runtime configuration has accumulated defensive fallbacks, hidden installers, and an unused CLIProxy service that make behavior harder to reason about. Simplifying these paths keeps the dotfiles predictable and aligned with Home Manager-managed state.

## What Changes

- Remove CLIProxy Home Manager integration and default enablement.
- Remove OpenClaw wrapper and managed OpenClaw config from AI tooling.
- Replace remaining dynamic `npx` execution with Nix-built or removed integrations.
- Remove graphify auto-install/update activation side effect.
- Rely on Home Manager-provided `XDG_*` and `EDITOR` values instead of local fallback expressions in managed shell snippets.
- Replace zsh-only POSIX-style tests with zsh `[[ ... ]]` conditionals.
- Keep multi-dot navigation vendored locally instead of fetching a small legacy plugin at build time.
- Make direnv layouts environment-only helpers that do not install packages or start services automatically.

## Capabilities

### New Capabilities
- `shell-runtime-config`: Shell runtime configuration remains simple, deterministic, and free of hidden service/install side effects.

### Modified Capabilities
- `openclaw-integration`: Remove OpenClaw CLI/config management requirements.

## Impact

- Affected code: Home Manager shell, direnv, AI CLI, module imports, and Darwin/Homebrew XDG trust handling.
- Removed systems: CLIProxy service/scripts/module, OpenClaw wrapper/config, and dynamic GitHub MCP `npx` configuration.
- Behavior change: direnv layouts no longer auto-install missing dependencies or start Docker Compose services.
