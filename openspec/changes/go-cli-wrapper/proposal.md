# Proposal: Go CLI Wrapper (dotfiles CLI)

## Problem

`install.sh` and `*-switch` shell scripts handle bootstrap + apply with poor UX:
- Bash limitations: error handling, cross-platform logic, no TUI
- Users must know correct switch script name per machine type
- No interactive feature flag selection on first run
- No unified `dotfiles` command

## Proposed CLI: `dotfiles`

### Commands

| Command | Description |
|---------|-------------|
| `dotfiles bootstrap` | Full install.sh replacement, phase-aware |
| `dotfiles apply` | Detects OS/arch, runs correct switch command |
| `dotfiles update` | `nix flake update` + apply |
| `dotfiles status` | Show current generation, what would change |
| `dotfiles init` | Interactive TUI — select features, writes `.user.nix` |

### Implementation

- Language: Go (cross-platform, single binary, no runtime deps)
- TUI: Bubble Tea (Charm) for feature flag selector
- Build: nix derivation in `flake.nix`, available as `pkgs.dotfiles-cli`
- Distribution: included in `home.packages` when built

### Feature flag TUI (`dotfiles init`)
On first run, interactive checklist:
```
[ ] Kubernetes tools (kubectl, k9s)
[ ] Network tools (nmap, mtr, trippy)
[ ] Podman
[x] AI tools (claude-code, gemini-cli, openspec)
[ ] Tmux  [x] Zellij (mutually exclusive)
```
Writes selections to `.user.nix`.

## Phasing

1. Phase 1: `dotfiles apply` + `dotfiles bootstrap` (replaces scripts)
2. Phase 2: `dotfiles init` TUI
3. Phase 3: `dotfiles status` + `dotfiles update`

## Relationship to install.sh

Go CLI replaces `install.sh` entirely. Keep `install.sh` until Phase 1 ships.
