## Why

Currently, the Archon development workflow (`agentic-dev-loop`) runs fully autonomously from planning to implementation. This can lead to the agent beginning code changes before a human developer has reviewed and approved the implementation plan. Adding an approval gate enforces a human-in-the-loop check.

## What Changes

- Enable `interactive: true` inside `.archon/workflows/development.yaml`.
- Add an `approve-plan` approval node right after the `plan` node, pausing the workflow for human approval before the `implement` node is executed.

## Capabilities

### New Capabilities

- `archon-approval-gate`: Integrated human-in-the-loop validation and plan approval gate for Archon workflows.

### Modified Capabilities

<!-- None -->

## Impact

- Workflow execution is paused after planning, requiring developer consent to proceed with code modifications.
