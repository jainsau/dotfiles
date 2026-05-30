## ADDED Requirements

### Requirement: Human-in-the-loop plan approval gate
The system SHALL pause the Archon development workflow to ask the user for approval before modifying any codebase files.

#### Scenario: Workflow pauses for human approval
- **WHEN** the `plan` phase of `agentic-dev-loop` completes successfully
- **THEN** the workflow enters a `paused` state at `approve-plan` and waits for explicit user approval before executing the `implement` node
