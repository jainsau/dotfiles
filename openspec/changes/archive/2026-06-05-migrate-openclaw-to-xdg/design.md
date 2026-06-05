## Context

Currently, OpenClaw configuration is placed at `~/.openclaw/openclaw.json`. To conform to XDG Base Directory Specification standards, we will migrate it to `~/.config/openclaw/openclaw.json`.

## Goals / Non-Goals

**Goals:**
- Manage OpenClaw configuration via `xdg.configFile."openclaw/openclaw.json"`.
- Export `OPENCLAW_CONFIG_PATH="$HOME/.config/openclaw/openclaw.json"` in both `openclaw` and `assistant` binary wrappers.

**Non-Goals:**
- Deleting the dynamic state folders created under `~/.openclaw` (like workspace/sandboxes/sessions) since they are mutable and transient.

## Decisions

### Decision 1: Export config path in openclaw-pkg wrapper
- **Rationale**: Setting `OPENCLAW_CONFIG_PATH` at wrapper execution level guarantees that all `openclaw` CLI invocations recognize our Home Manager managed config file without manual environment overrides.

## Risks / Trade-offs

None.
