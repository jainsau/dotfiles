## ADDED Requirements

### Requirement: Declarative force-overwrite mimeapps.list
The system SHALL declaratively write and forcefully overwrite `~/.config/mimeapps.list` using Home Manager.

#### Scenario: Forcefully overwrite existing mimeapps.list
- **WHEN** Home Manager configuration is successfully applied via `hma-switch`
- **THEN** `~/.config/mimeapps.list` is present, contains `[Default Applications]`, and overwrites any existing manual file
