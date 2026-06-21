## ADDED Requirements

### Requirement: Suspended job resume picker
The shell configuration SHALL provide an interactive shortcut that lists current shell jobs and resumes the selected job in the foreground.

#### Scenario: Resume selected job
- **WHEN** the user presses the configured job-resume shortcut in an interactive Zsh session with at least one shell job
- **THEN** the shell displays the jobs in a fuzzy picker and foregrounds the selected job

#### Scenario: No jobs available
- **WHEN** the user presses the configured job-resume shortcut in an interactive Zsh session with no shell jobs
- **THEN** the shell returns to the prompt without executing a foreground command
