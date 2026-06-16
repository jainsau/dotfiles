## Why

Fresh dotfiles clones can start Pi before `~/.pi/agent/compact-config.json` exists. The rhubarb-pi compact-config extension treats the missing file as a load failure and logs noise until the user opens `/compact-config`.

## What Changes

- Seed Pi compact-config JSON during Home Manager activation when missing.
- Keep the seeded file mutable so the Pi extension can update thresholds normally.
- Also seed the historically mistyped `compacti-config.json` path used in setup notes.

## Scope

- Does not set any model-specific thresholds by default.
- Does not overwrite existing user compaction threshold files.
