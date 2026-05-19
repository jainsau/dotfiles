---
name: openspec-propose
description: Propose a new change with all artifacts generated in one step. Use when the user wants to describe what they want to build and get a complete proposal with design, specs, and tasks ready for implementation.
---

Propose a new change - create the change and generate all artifacts in one step.

Creates a change with artifacts:
- proposal.md (what & why)
- design.md (how)
- tasks.md (implementation steps)

When ready to implement, use the apply skill.

## Steps

1. **If no clear input provided, ask what they want to build**

   From their description, derive a kebab-case name (e.g., "add user authentication" → `add-user-auth`).

2. **Create the change directory**
   ```bash
   openspec new change "<name>"
   ```

3. **Get the artifact build order**
   ```bash
   openspec status --change "<name>" --json
   ```
   Parse the JSON to get `applyRequires` and `artifacts` with status/dependencies.

4. **Create artifacts in sequence until apply-ready**

   Loop through artifacts in dependency order:

   a. For each artifact that is `ready` (dependencies satisfied):
      - Get instructions: `openspec instructions <artifact-id> --change "<name>" --json`
      - Read any completed dependency files for context
      - Create the artifact file using `template` as the structure
      - Apply `context` and `rules` as constraints — do NOT copy them into the file

   b. Continue until all `applyRequires` artifacts are complete

   c. If an artifact requires user input, ask for clarification

5. **Show final status**
   ```bash
   openspec status --change "<name>"
   ```

## Output

After completing all artifacts, summarize:
- Change name and location
- List of artifacts created
- "All artifacts created! Ready for implementation."
- Suggest using the apply skill to start implementing

## Guardrails

- Create ALL artifacts needed for implementation (as defined by schema's `apply.requires`)
- Always read dependency artifacts before creating a new one
- If context is critically unclear, ask — but prefer making reasonable decisions to keep momentum
- If a change with that name already exists, ask if user wants to continue it or create a new one
- `context` and `rules` from instructions are constraints for YOU, not content for the file
