## ADDED Requirements

### Requirement: Compact Config Bootstrap

The Home Manager Pi tooling setup SHALL create a valid mutable compact-config JSON file for first-time installs without overwriting an existing user-edited file.

#### Scenario: First Home Manager activation
- **WHEN** Home Manager activates on a machine where `~/.pi/agent/compact-config.json` does not exist
- **THEN** the activation SHALL create `~/.pi/agent/compact-config.json` containing an empty `thresholds` object
- **AND** later Pi extension writes SHALL be able to modify the file normally

#### Scenario: Existing compact config is preserved
- **WHEN** Home Manager activates on a machine where `~/.pi/agent/compact-config.json` already exists
- **THEN** the activation SHALL leave the existing file unchanged
