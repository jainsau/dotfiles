# gh-cli Specification

## Purpose
TBD - created by archiving change add-gh-cli. Update Purpose after archive.
## Requirements
### Requirement: Declarative GitHub CLI installation
The system SHALL install the GitHub CLI and configure it declaratively via Home Manager's `programs.gh` module.

#### Scenario: Verify gh installation and default settings
- **WHEN** Home Manager configuration is successfully applied via `dma-switch` or `hma-switch`
- **THEN** the `gh` command is available, and `~/.config/gh/config.yml` contains `git_protocol: ssh`.

