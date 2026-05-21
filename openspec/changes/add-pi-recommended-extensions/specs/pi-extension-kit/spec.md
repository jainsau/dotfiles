## ADDED Requirements

### Requirement: Declarative Pi extension packages
The dotfiles configuration SHALL declare curated Pi extension packages in `kit.yml` so Pi tooling can be reproduced by pi-depo across machines.

#### Scenario: New extension package is added
- **WHEN** a Pi extension package is selected for use
- **THEN** it SHALL be represented as a package entry in `kit.yml` with a source and rating

#### Scenario: Experimental extension package is added
- **WHEN** a package has uncertain compatibility or needs evaluation
- **THEN** it SHALL be marked `debatable` instead of `core`

### Requirement: Existing Pi package choices are preserved
The dotfiles configuration SHALL preserve existing package entries unless a package is explicitly replaced.

#### Scenario: Adding recommended extensions
- **WHEN** recommended extensions are added
- **THEN** existing packages such as `pi-subagents`, `pi-mcp`, `pi-github`, and `pi-web-access` SHALL remain declared

### Requirement: Direct main workflow remains prohibited
The Pi extension kit SHALL not introduce a workflow that encourages direct commits or pushes to the default branch.

#### Scenario: Cross-repo agent work uses Git
- **WHEN** an agent makes repository changes
- **THEN** changes SHALL be performed on feature branches and submitted through PRs
