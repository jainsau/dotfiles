## Context

Existing manual files inside `~/.config/` can sometimes trigger "would be clobbered" errors on Home Manager activation, halting deployment. We want to add a declarative `mimeapps.list` with the `force = true` option to avoid this.

## Goals / Non-Goals

**Goals:**
- Declaratively deploy a default `mimeapps.list`.
- Forcefully overwrite any pre-existing local copy of `mimeapps.list` to ensure smooth HM activations.

**Non-Goals:**
- Implementing standard `xdg.mimeApps.enable` which throws platform assertion errors on macOS.

## Decisions

- **Add `xdg.configFile."mimeapps.list"` in `nix/home-manager/default.nix`:** Placing it here keeps the root-level user config cohesive, and setting `force = true` instructs Home Manager to safely overwrite any existing conflicting files.

## Risks / Trade-offs

- **Risk:** Existing manual mime associations are replaced.
  - **Mitigation:** Any custom mappings can be cleanly added declaratively inside this Nix file going forward.
