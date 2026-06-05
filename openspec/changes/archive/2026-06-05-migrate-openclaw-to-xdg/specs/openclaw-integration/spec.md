## MODIFIED Requirements

### Requirement: OpenClaw execution
The system SHALL provide a globally available `openclaw` executable that executes `openclaw@latest` dynamically using Node/npx, pre-configured with the XDG config path.

#### Scenario: Running openclaw command
- **WHEN** user runs `openclaw` in the terminal
- **THEN** system executes the openclaw package dynamically using npx with `OPENCLAW_CONFIG_PATH` set to the XDG config path

### Requirement: Central Assistant launcher
The system SHALL provide a globally available `assistant` launcher that executes `openclaw` with the declarative XDG configuration file path.

#### Scenario: Running assistant command
- **WHEN** user runs `assistant` in the terminal
- **THEN** system executes openclaw with `OPENCLAW_CONFIG_PATH` set to `~/.config/openclaw/openclaw.json`

### Requirement: Declarative configuration file
The system SHALL manage the OpenClaw configuration file at `~/.config/openclaw/openclaw.json` as a Home Manager managed XDG config file.

#### Scenario: OpenClaw configuration file presence
- **WHEN** Home Manager configuration is applied
- **THEN** system ensures `~/.config/openclaw/openclaw.json` is linked with valid workspace settings
