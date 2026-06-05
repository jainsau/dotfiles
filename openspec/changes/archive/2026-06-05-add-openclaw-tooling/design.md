## Context

Currently, AI modules in this dotfiles repository include several CLI utilities like `kiro-cli`, `claude-code`, etc. We are adding `openclaw` to our CLI toolkit. To support both an unbranded launch and a pre-configured launcher, we want to provide `openclaw` and `assistant` commands. To keep our environment purely declarative, the openclaw configuration files must be managed by Home Manager in the user's home directory.

## Goals / Non-Goals

**Goals:**
- Provide globally available `openclaw` and `assistant` wrappers.
- Manage `~/.openclaw/openclaw.json` declaratively using Home Manager `home.file`.

**Non-Goals:**
- Full custom Nix packaging of OpenClaw from source is out of scope (using dynamic `npx` execution is highly performant and flexible).

## Decisions

### Decision 1: Wrap OpenClaw via Node/npx
- **Rationale**: Wrapping `openclaw@latest` via `npx` provides dynamic execution with fully cached, sandboxed execution without having to compile/package it natively in Nix.
- **Alternative**: Packaging natively via `buildNpmPackage` would require constant updates to keep up with `openclaw@latest` releases.

### Decision 2: Declarative Configuration File at `~/.openclaw/openclaw.json`
- **Rationale**: We define the configuration using Home Manager's `home.file` module. Both `openclaw-pkg` and `assistant-pkg` can load/reference this standard configuration file, keeping it checked into git dotfiles.
- **Alternative**: Hardcoding a private path or using untracked file settings would leak secrets or lead to configuration drift across systems.

## Risks / Trade-offs

- [Risk] Node/npx execution requires a network connection on the first launch.
  - [Mitigation] This is acceptable for developer toolboxes, and subsequent executions are served instantly from the local npm cache.
