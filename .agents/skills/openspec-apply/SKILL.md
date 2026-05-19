---
name: openspec-apply
description: Implement tasks from an OpenSpec change. Use when the user wants to start implementing, continue implementation, or work through tasks.
---

Implement tasks from an OpenSpec change.

## Steps

1. **Select the change**

   If a name is provided, use it. Otherwise:
   - Infer from conversation context if the user mentioned a change
   - Auto-select if only one active change exists
   - If ambiguous, run `openspec list --json` and ask the user to select

2. **Check status**
   ```bash
   openspec status --change "<name>" --json
   ```
   Parse to understand `schemaName` and which artifact contains tasks.

3. **Get apply instructions**
   ```bash
   openspec instructions apply --change "<name>" --json
   ```
   Returns `contextFiles`, progress, task list, and dynamic instruction.

   Handle states:
   - `state: "blocked"`: show message, suggest completing missing artifacts
   - `state: "all_done"`: congratulate, suggest archive
   - Otherwise: proceed to implementation

4. **Read context files**

   Read every file path listed under `contextFiles` from the apply instructions output.

5. **Show current progress**

   Display schema, progress ("N/M tasks complete"), remaining tasks, dynamic instruction.

6. **Implement tasks (loop until done or blocked)**

   For each pending task:
   - Show which task is being worked on
   - Make the code changes required
   - Keep changes minimal and focused
   - Mark task complete: `- [ ]` → `- [x]`
   - Continue to next task

   Pause if:
   - Task is unclear → ask for clarification
   - Implementation reveals a design issue → suggest updating artifacts
   - Error or blocker encountered → report and wait

7. **On completion or pause, show status**

   Display tasks completed this session, overall progress, and next steps.

## Guardrails

- Keep going through tasks until done or blocked
- Always read context files before starting
- If task is ambiguous, pause and ask before implementing
- Keep code changes minimal and scoped to each task
- Update task checkbox immediately after completing each task
- Pause on errors, blockers, or unclear requirements — don't guess
- Use contextFiles from CLI output, don't assume specific file names
