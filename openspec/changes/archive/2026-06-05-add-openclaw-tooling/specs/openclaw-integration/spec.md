## ADDED Requirements

### Requirement: OpenClaw execution
The system SHALL provide a globally available `openclaw` executable that executes `openclaw@latest` dynamically using Node/npx.

#### Scenario: Running openclaw command
- **WHEN** user runs `openclaw` in the terminal
- **THEN** system executes the openclaw package dynamically using npx

### Requirement: Central Assistant launcher
The system SHALL provide a globally available `assistant` launcher that executes `openclaw` with the declarative configuration file path.

#### Scenario: Running assistant command
- **WHEN** user runs `assistant` in the terminal
- **THEN** system executes openclaw with `--config $HOME/.openclaw/openclaw.json`

### Requirement: Declarative configuration file
The system SHALL manage the OpenClaw configuration file at `~/.openclaw/openclaw.json` as a Home Manager managed file.

#### Scenario: OpenClaw configuration file presence
- **WHEN** Home Manager configuration is applied
- **THEN** system ensures `~/.openclaw/openclaw.json` is linked with valid workspace settings
