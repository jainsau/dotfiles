## Context

To provide developer oversight and prevent unwanted file edits, we want to place an interactive approval gate in our development workflow between planning and implementation.

## Goals / Non-Goals

**Goals:**
- Insert an approval gate `approve-plan` in `.archon/workflows/development.yaml`.
- Pause workflow execution and request developer input.

**Non-Goals:**
- Creating complex conditional branches on rejection (simple cancel or comment capture is sufficient).

## Decisions

- **Set `interactive: true` on the workflow:** Required by Archon to render approval prompt gates interactively in user/chat environments.
- **Insert `approve-plan` using `approval` node format:** Pauses execution and auto-resumes once approved.

## Risks / Trade-offs

- **Risk:** workflow stays paused indefinitely if ignored.
  - **Mitigation:** Safe, as developers can resume or cancel the run via CLI/UI anytime.
