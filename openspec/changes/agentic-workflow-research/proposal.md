## Why

We are trying to devise a deterministic, repeatable, and highly structured agentic workflow mechanism. Combining multiple specialized tools can give AI agents the structural guardrails and context needed to operate predictably within this codebase.

## What Changes

This is an exploratory research phase to evaluate the synthesis of these distinct tools into a cohesive workflow engine.

### Key Research Areas

1. **Archon & Pi Integration**
   - Investigate using **Archon** (for structured orchestration, robust control planes, or sub-agent delegation) in combination with **Pi** (our primary coding agent harness).
   - How can Archon provide deterministic boundaries or strict planning steps that Pi then executes?

2. **Code Intelligence (SCIP + Graphify)**
   - **SCIP (Code Intelligence Protocol)**: Provides precise, deterministic symbol navigation (definitions, references, project trees).
   - **Graphify**: Generates structural graph mappings of the codebase.
   - Together, they eliminate agent "hallucinations" about code structure, allowing Pi to navigate the repository deterministically rather than relying on unstructured file reads.

3. **OpenSpec for State & Verification**
   - **OpenSpec**: Acts as the immutable ledger for architectural intent and requirements.
   - The workflow loop: OpenSpec defines the boundary/task $\rightarrow$ Archon plans $\rightarrow$ SCIP/Graphify provides structural context $\rightarrow$ Pi executes $\rightarrow$ OpenSpec validates the resulting state.

4. **Fit-for-Purpose Model Routing**
   - We must avoid using massive "world models" for every single step.
   - Route simpler, deterministic tasks (e.g., basic code extraction, parsing, SCIP graph traversal) to smaller, faster, or local models.
   - Reserve high-capability frontier models for complex architectural reasoning and planning.

## Capabilities

### New Capabilities
- `agentic-workflow-research`: Exploration of combining Archon, Pi, SCIP, Graphify, and OpenSpec for deterministic agent workflows.

### Modified Capabilities

## Impact

- Will inform how we author Agent Skills.
- Could lead to new `.pi/extensions/` to glue Archon and OpenSpec together.
- Defines the future architectural methodology of this repository.