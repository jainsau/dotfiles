## Context

Neovim developers often need to inspect who wrote a line, what commit introduced it, and view detailed diffs or go back in history. We will add `blame.nvim` to provide this natively.

## Goals / Non-Goals

**Goals:**
- Declaratively install and configure `FabijanZulj/blame.nvim`.
- Bind the toggle command to the `<leader>gb` hotkey.

**Non-Goals:**
- Changing existing `gitsigns` options (which can coexist cleanly with a full blame sidebar).

## Decisions

- **Isolate plugin config in `nix/home-manager/editors/nvim/lua/plugins/blame.lua`:** Following lazy.nvim structure, placing the configuration in its own file makes it modular and self-contained.

## Risks / Trade-offs

- **Risk:** Keybinding conflicts.
  - **Mitigation:** Verified that `<leader>gb` is completely unmapped, making it a safe choice.
