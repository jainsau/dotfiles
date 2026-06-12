## ADDED Requirements

### Requirement: Install Apple Container CLI
The Darwin configuration SHALL install Apple's `container` CLI on supported Apple Silicon macOS systems using nix-darwin's Homebrew integration.

#### Scenario: Apple Silicon Darwin activation installs container
- **WHEN** nix-darwin activation runs on an Apple Silicon Darwin system
- **THEN** Homebrew installs the `container` formula
- **AND** the `container` executable is available on the user's PATH

#### Scenario: Non-Apple-Silicon systems do not install container
- **WHEN** the configuration evaluates for a non-Apple-Silicon system
- **THEN** the `container` Homebrew formula is not included in the configured brew list
