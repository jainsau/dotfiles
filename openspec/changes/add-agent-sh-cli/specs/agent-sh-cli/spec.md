## ADDED Requirements

### Requirement: Nix-managed agent-sh CLI

When AI tools are enabled, Home Manager SHALL install `agent-sh` through Nix rather than requiring a global npm install.

#### Scenario: User can run agent-sh

- **GIVEN** `tools.enableAiTools` is enabled
- **WHEN** the Home Manager configuration is applied
- **THEN** the `agent-sh` executable is available in the user's environment

### Requirement: Nix-managed Pi bridge extension

When AI tools are enabled, Home Manager SHALL expose the bundled `pi-bridge` extension without requiring `agent-sh install pi-bridge`.

#### Scenario: agent-sh can discover pi-bridge

- **GIVEN** `tools.enableAiTools` is enabled
- **WHEN** the Home Manager configuration is applied
- **THEN** `~/.agent-sh/extensions/pi-bridge` points to the Nix-managed bundled extension
