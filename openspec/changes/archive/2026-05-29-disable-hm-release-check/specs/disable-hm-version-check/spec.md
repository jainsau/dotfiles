## ADDED Requirements

### Requirement: Disable Home Manager Nixpkgs version check
The system SHALL disable the Home Manager Nixpkgs release version check to suppress mismatch warnings on system activations.

#### Scenario: Verify version check is disabled
- **WHEN** Home Manager configuration is successfully applied via `hma-switch`
- **THEN** Home Manager applies the `home.enableNixpkgsReleaseCheck = false` option to suppress mismatch warnings
