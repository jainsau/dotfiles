## Why

Integrating OpenClaw as a high-performance unbranded executable and Nava central Assistant launcher ensures global availability of state-of-the-art multi-agent capabilities. Managing its configuration file (`~/.openclaw/openclaw.json`) declaratively via Home Manager aligns with our dotfiles philosophy, avoiding untracked states and keeping configuration source-controlled.

## What Changes

- Package unbranded `openclaw` via dynamic `npx` execution.
- Package `assistant` central launcher wrapper around `openclaw@latest` with configuration.
- Manage OpenClaw configuration file (`~/.openclaw/openclaw.json`) declaratively via Home Manager linked files.

## Capabilities

### New Capabilities
- `openclaw-integration`: Declaratively manage OpenClaw tools and configuration files under Nix and Home Manager.

### Modified Capabilities
None

## Impact

- Adds `openclaw` and `assistant` commands to user PATH.
- Manages `~/.openclaw/openclaw.json` as a symlinked file in the home directory via Home Manager.
- Avoids untracked or hardcoded configuration paths.
