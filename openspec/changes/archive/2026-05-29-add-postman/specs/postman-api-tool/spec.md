## ADDED Requirements

### Requirement: Install Postman GUI
The system SHALL install the Postman GUI application on macOS via Homebrew casks.

#### Scenario: Postman is installed
- **WHEN** nix-darwin system activation completes successfully
- **THEN** Postman.app is present in the Applications folder
