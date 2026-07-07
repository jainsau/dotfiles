## ADDED Requirements

### Requirement: Podman Compose availability

The configuration SHALL install Podman Compose alongside Podman on supported platforms.

#### Scenario: Linux user environment includes Podman Compose

- **GIVEN** the Podman tooling module is enabled on Linux
- **WHEN** Home Manager is applied
- **THEN** `podman-compose` is available in the user's environment

#### Scenario: Darwin Homebrew includes Podman Compose

- **GIVEN** the Darwin configuration is applied
- **WHEN** Homebrew activation completes
- **THEN** `podman-compose` is installed by Homebrew

### Requirement: Darwin evaluation safety

The Home Manager Podman module SHALL NOT evaluate Linux-only nixpkgs Podman packages on Darwin.

#### Scenario: Darwin Home Manager evaluation

- **GIVEN** the host platform is `aarch64-darwin`
- **WHEN** the Home Manager configuration evaluates
- **THEN** it does not include `pkgs.podman` or `pkgs.podman-compose` in `home.packages`
