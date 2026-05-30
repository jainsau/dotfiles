## Why

We currently describe our agentic pipeline inside OpenSpec specifications, but we lack a concrete, executable Archon YAML workflow file. Creating this file allows the Archon CLI to orchestrate the entire development loop (planning, implementation, verification, and code quality reviews) deterministically.

## What Changes

- Create `.archon/workflows/development.yaml` containing the declarative YAML definition of our development workflow.

## Capabilities

### New Capabilities

- `archon-workflow`: Executable multi-stage software development loop configured via Archon YAML.

### Modified Capabilities

<!-- None -->

## Impact

- Allows users to run `archon workflow run agentic-dev-loop` in this repository to automate tasks.
