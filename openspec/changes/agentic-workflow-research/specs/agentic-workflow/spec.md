## ADDED Requirements

### Requirement: Deterministic Agent Workflows
The system SHALL combine multiple tools to produce deterministic AI behavior.

#### Scenario: Agent plans and executes a change
- **WHEN** a change is requested
- **THEN** OpenSpec SHALL define the task, SCIP/Graphify SHALL provide the code graph, Archon SHALL orchestrate the plan, and Pi SHALL execute it

### Requirement: Structural Context Verification
Agents SHALL NOT guess codebase structures.

#### Scenario: Agent modifies an existing module
- **WHEN** the agent needs to find a module
- **THEN** it SHALL use SCIP and Graphify to deterministically locate it

### Requirement: Fit-for-Purpose Model Routing
The workflow SHALL route tasks to appropriately sized models based on complexity.

#### Scenario: Delegating sub-tasks
- **WHEN** a workflow step involves simple tasks (e.g., symbol lookups, linting, basic parsing)
- **THEN** it SHALL use smaller, local, or specialized models
- **AND WHEN** a step requires complex architectural reasoning
- **THEN** it SHALL use frontier "world" models