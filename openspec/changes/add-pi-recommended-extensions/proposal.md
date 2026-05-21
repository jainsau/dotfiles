## Why

The dotfiles repo already uses `kit.yml` as the declarative source of truth for Pi packages, but the current package set is missing several reviewed extensions that improve safe autonomous development, code intelligence, and long-running agent workflows. Adding these through `kit.yml` keeps Pi setup reproducible across machines instead of relying on ad-hoc local installs.

## What Changes

- Add curated Pi extension packages to `kit.yml` for safety, review, code intelligence, and workflow productivity.
- Prefer package-level installation with explicit extension filters where available to avoid enabling unnecessary or experimental modules.
- Preserve existing installed packages and avoid direct one-off `pi install` changes outside the kit.
- Mark riskier/community extensions as `debatable` where they require evaluation before becoming core workflow dependencies.

## Capabilities

### New Capabilities
- `pi-extension-kit`: Declarative installation of curated Pi extensions through `kit.yml` for reproducible agent tooling.

### Modified Capabilities

## Impact

- Affects `kit.yml` package declarations.
- May affect local Pi package sync behavior through `pd sync` / pi-depo.
- Adds optional runtime extensions for permissioning, checkpoint/repeat workflows, code intelligence, and safe Git operations.
- Does not change Nix system packages or Home Manager module behavior.
