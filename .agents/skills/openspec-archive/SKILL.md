---
name: openspec-archive
description: Archive a completed change. Use when the user wants to finalize and archive a change after implementation is complete.
---

Archive a completed change.

## Steps

1. **Select the change**

   If no name provided, run `openspec list --json` and ask the user to select.
   Show only active changes (not already archived).

2. **Check artifact completion**
   ```bash
   openspec status --change "<name>" --json
   ```
   If any artifacts are not `done`, warn and confirm before proceeding.

3. **Check task completion**

   Read the tasks file. If incomplete tasks found, warn and confirm.

4. **Assess delta spec sync**

   Check for delta specs at `openspec/changes/<name>/specs/`. If they exist:
   - Compare with main specs at `openspec/specs/`
   - Show summary of what would change
   - Offer: "Sync now (recommended)" or "Archive without syncing"

5. **Perform the archive**
   ```bash
   mkdir -p openspec/changes/archive
   mv openspec/changes/<name> openspec/changes/archive/YYYY-MM-DD-<name>
   ```
   Check if target already exists before moving.

6. **Display summary**

   Show: change name, schema used, archive location, spec sync status, any warnings.

## Guardrails

- Always prompt for change selection if not provided
- Don't block archive on warnings — just inform and confirm
- Preserve .openspec.yaml when moving (it moves with the directory)
- If delta specs exist, always assess sync state before prompting
