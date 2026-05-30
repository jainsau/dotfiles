## Context

While our agentic loop concepts are well-specified, they must be represented as a concrete and executable workflow definition in Archon's native format.

## Goals / Non-Goals

**Goals:**
- Create an executable `.archon/workflows/development.yaml` file.
- Outline stages for planning, implementation, verification, parallel reviews, and automated self-repair.

**Non-Goals:**
- Customizing native Archon CLI commands (we will leverage default built-in commands like `archon-create-plan`, `archon-implement-tasks`, and `archon-code-review-agent`).

## Decisions

- **Store the workflow under `.archon/workflows/development.yaml`:** This is the standard workspace-recursive path parsed automatically by Archon CLI.

## Risks / Trade-offs

- **Risk:** Pathing issues with external executables.
  - **Mitigation:** Safe, since we use default built-in Archon command abstractions which automatically find their respective binaries inside the environment.
