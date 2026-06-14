## REMOVED Requirements

### Requirement: OpenClaw execution

The system SHALL provide a globally available `openclaw` executable that executes `openclaw@latest` dynamically using Node/npx, pre-configured with the XDG config path.

#### Scenario: Running openclaw command

- **WHEN** user runs `openclaw` in the terminal
- **THEN** system executes the openclaw package dynamically using npx with `OPENCLAW_CONFIG_PATH` set to the XDG config path

### Requirement: Declarative configuration file

The system SHALL manage the OpenClaw configuration file at `~/.config/openclaw/openclaw.json` as a Home Manager managed XDG config file.

#### Scenario: OpenClaw configuration file presence

- **WHEN** Home Manager configuration is applied
- **THEN** system ensures `~/.config/openclaw/openclaw.json` is linked with valid workspace settings
