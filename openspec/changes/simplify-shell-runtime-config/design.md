## Overview

Simplify shell runtime behavior by removing unused CLIProxy plumbing, reducing defensive shell fallbacks in Home Manager-managed scripts, and making development helpers explicit rather than side-effecting.

## Decisions

- Keep runtime secrets directly at `$XDG_CONFIG_HOME/.secrets.env` and outside Home Manager file management.
- Source secrets from `$XDG_CONFIG_HOME/.secrets.env` because Home Manager already sets `XDG_CONFIG_HOME`.
- Vendor `manydots-magic` as a local zsh helper because the upstream script is tiny and stable.
- Keep direnv layouts as PATH/environment helpers only; dependency installation and service startup should be explicit user actions.
- Remove CLIProxy entirely from the module graph because it is unused and not behaving as expected.
- Remove OpenClaw entirely from AI tooling because it is redundant with Pi/agentic.nvim and adds another dynamic npx surface.

## Risks

- Projects relying on direnv auto-install behavior must now install dependencies explicitly.
- CLIProxy commands/services will no longer exist after switching.
- The `openclaw` command and managed OpenClaw config file will no longer be installed.

## Alternatives Considered

- Keep CLIProxy disabled but present: rejected because it preserves unused surface area.
- Keep defensive shell fallbacks: rejected because Home Manager owns the runtime environment.
