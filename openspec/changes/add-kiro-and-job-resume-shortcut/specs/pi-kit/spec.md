## ADDED Requirements

### Requirement: Kiro provider package in kit
The Pi kit manifest SHALL include the Kiro provider/login extension package so Pi installations can reproduce Kiro login and provider support from the kit.

#### Scenario: Inspect kit manifest
- **WHEN** a user inspects `kit.yml`
- **THEN** the manifest includes a package entry whose source is `npm:pi-provider-kiro`
