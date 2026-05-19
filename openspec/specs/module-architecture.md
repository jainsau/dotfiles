## CURRENT Requirements

### Requirement: Module structure conventions
Each module follows a co-location pattern: package + alias + completion live in the same file.

#### Scenario: Tool with meaningful config
- **WHEN** a tool has more than package + alias (e.g. kubectl, fzf, tmux)
- **THEN** it gets a dedicated module file in the appropriate subdirectory

#### Scenario: Simple utility tool
- **WHEN** a tool only needs package + optional alias
- **THEN** it lives in the grouped `cli/tools.nix` file

### Requirement: Module responsibility boundaries

| What | Where | Rule |
|------|-------|------|
| Package + its aliases | Same module as tool | Co-locate with tool |
| Shell functions | `shell/functions.nix` | Unless tightly coupled to specific tool |
| Keybindings / ZLE widgets | `shell/keybindings.nix` | All input handling in one place |
| Tool completions + alias | With tool module | Completion depends on binary |
| Platform conditionals | Inline `lib.optionals` | Keep close to package |
| General session vars | `default.nix` | Cross-cutting concerns only |

### Requirement: Feature flag pattern
Every optional tool category must have a corresponding `tools.enableX` option in `modules/default.nix`.

#### Scenario: Optional tool enabled
- **WHEN** `config.tools.enableX = true` (default)
- **THEN** module installs packages, sets aliases, configures shell integration

#### Scenario: Optional tool disabled
- **WHEN** `config.tools.enableX = false` (via `.user.nix`)
- **THEN** module contributes nothing to the profile

### Requirement: Module enable flags registry
Defined flags in `modules/default.nix`:
- `enableTmux` — tmux multiplexer
- `enableZellij` — zellij multiplexer (mutually exclusive with tmux)
- `enableKubernetes` — kubectl, k9s, completions
- `enableNetworkTools` — nmap, mtr, trippy
- `enablePodman` — podman + alias
- `enableAiTools` — kiro-cli, claude-code, gemini-cli, openspec
- `enableMonitoring` — btop, bottom, htop

### Requirement: Known bug — podman uses wrong flag
- **WHEN** `config.tools.enableMonitoring` is checked in `system/podman.nix:6`
- **THEN** this is WRONG — podman should use `config.tools.enablePodman`
- Fix: add `enablePodman` option, update podman.nix
