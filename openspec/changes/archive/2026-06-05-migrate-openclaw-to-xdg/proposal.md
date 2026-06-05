## Why

To comply with the XDG Base Directory Specification and maintain a clean user home directory, the OpenClaw configuration file should live under `$XDG_CONFIG_HOME/openclaw/openclaw.json` (typically `~/.config/openclaw/openclaw.json`) instead of `~/.openclaw/openclaw.json`.

## What Changes

- Migrate OpenClaw configuration file from `home.file.".openclaw/openclaw.json"` to `xdg.configFile."openclaw/openclaw.json"`.
- Update both `openclaw-pkg` and `assistant-pkg` launchers to export `OPENCLAW_CONFIG_PATH="$HOME/.config/openclaw/openclaw.json"`.

## Capabilities

### New Capabilities
None

### Modified Capabilities
- `openclaw-integration`: Update configuration path specification to conform to XDG Base Directory standard.

## Impact

- Cleans up `~/.openclaw/openclaw.json` from the root of the home directory (leaving only transient state directories in `~/.openclaw` if any).
- Uses `~/.config/openclaw/openclaw.json` for managed OpenClaw configuration.
