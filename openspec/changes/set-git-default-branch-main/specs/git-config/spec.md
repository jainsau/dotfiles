## ADDED Requirements

### Requirement: Default initial branch
The dotfiles-managed Git configuration SHALL set the default initial branch for newly initialized repositories to `main`.

#### Scenario: Initialize a new repository
- **WHEN** Git is configured by Home Manager from this dotfiles repository
- **THEN** `git init` creates a repository whose initial branch is `main`
