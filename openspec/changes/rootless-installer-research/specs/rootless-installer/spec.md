## ADDED Requirements

### Requirement: Rootless Installation
The installer SHALL support environments without sudo privileges.

#### Scenario: Running on a locked-down corporate laptop
- **WHEN** the user runs the installer without root access
- **THEN** it SHALL use mechanisms like `proot` or `nix-portable` to install Nix into `$HOME/nix`

### Requirement: Installer UX Abstraction
The installer SHALL abstract Nix complexity from the user.

#### Scenario: First-time setup
- **WHEN** the user runs the bootstrap command
- **THEN** the installer SHALL handle Nix installation silently, similar to the devbox experience