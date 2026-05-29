# archon-tooling Specification

## Purpose
TBD - created by archiving change install-archon-tooling. Update Purpose after archive.
## Requirements
### Requirement: Install Archon CLI via Nix-darwin
The system SHALL install the Archon CLI declaratively using Nix-darwin's Homebrew tap integration.

#### Scenario: Verify Archon CLI is installed
- **WHEN** Nix-darwin activation is successfully run
- **THEN** the `archon` executable is available in the shell

### Requirement: Install pi-archon plugin via kit.yml
The system SHALL declare the `pi-archon` extension in `kit.yml` to support declarative Pi environments.

#### Scenario: Verify pi-archon plugin is configured
- **WHEN** `kit.yml` is parsed
- **THEN** the `pi-archon` plugin is listed under packages with `source: git:github.com/loopyd/pi-archon`

