## Context

`kit.yml` is the declarative package list used by pi-depo to reproduce Pi packages across machines. The current kit already includes core packages such as `pi-subagents`, `pi-mcp`, `pi-github`, `pi-web-access`, and `caveman`.

The reviewed Pi ecosystem packages provide useful extensions, but some overlap with existing packages or carry higher runtime risk. The design should therefore add only high-signal packages to `kit.yml`, keep experimental entries explicitly marked, and avoid one-off local installs.

## Goals / Non-Goals

**Goals:**

- Keep Pi extension installation declarative through `kit.yml`.
- Add curated packages that improve safe autonomous development and cross-repo work.
- Avoid duplicating capabilities already covered by installed packages where possible.
- Make risk/priority visible via package ratings.

**Non-Goals:**

- Do not vendor extension source into this repo.
- Do not create project-local `.pi/extensions` or global dotfiles-managed extension files.
- Do not bypass `kit.yml` with direct `pi install` as the source of truth.
- Do not change Home Manager/Nix package installation.

## Decisions

- **Use `kit.yml` as source of truth.** This matches the existing dotfiles pattern and allows pi-depo to reconcile installs across machines.
- **Add `pi-hooks` as useful.** It provides checkpoint, LSP, permission, repeat, and token-rate extensions as an npm Pi package with a manifest.
- **Add `rhubarb-pi` as debatable with selected extensions.** Safe-git, safe-rm, background notifications, and SCIP tooling are useful, but the package is community-maintained and should be evaluated before promoting to useful/core.
- **Avoid adding another subagent package.** `pi-subagents` is already installed and should remain the default orchestration mechanism.
- **Avoid adding overlapping web search packages for now.** `pi-web-access` is already installed; Firecrawl-specific tooling can be added later if needed as a dedicated package or local extension after compatibility review.

## Risks / Trade-offs

- **Package compatibility risk** → Keep community packages as `debatable` when compatibility is uncertain.
- **Extension overlap/noise** → Prefer selected extension filters where possible.
- **Runtime safety risk** → Favor safety/permission/checkpoint extensions first and avoid enabling broad experimental extension sets.
- **Gist drift risk** → Changes should be pushed through the existing pi-depo flow after review, not manually installed outside `kit.yml`.

## Migration Plan

1. Update `kit.yml` with selected package entries.
2. Validate YAML shape and inspect `pd diff` where possible.
3. After PR review, run the normal pi-depo sync flow to install/reconcile packages.
4. Use `pi list` and `/reload` to verify loaded packages/extensions.

## Open Questions

- Whether `rhubarb-pi` selected extensions load cleanly with the currently installed Pi version.
- Whether Firecrawl-specific tools should become a dedicated Nava package later.
