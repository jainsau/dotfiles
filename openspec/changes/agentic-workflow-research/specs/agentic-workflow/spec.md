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