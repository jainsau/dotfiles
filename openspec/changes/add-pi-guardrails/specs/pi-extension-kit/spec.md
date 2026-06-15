## ADDED Requirements

### Requirement: Guardrails Package

The Pi extension kit SHALL include a guardrails package that provides workspace/file access and risky-command protections while preserving existing rhubarb-pi utility coverage.

#### Scenario: Declarative guardrails installation
- **WHEN** the Pi extension kit is synced on a new machine
- **THEN** `npm:@aliou/pi-guardrails` SHALL be installed as part of the package set
- **AND** `rhubarb-pi` SHALL remain available for SCIP and selected utility extensions
