## Why

The Neovim editor does not currently have an interactive Git blame visualization tool. Adding a visual blame plugin (`blame.nvim`) allows users to declaratively view author and commit info per line, navigate file history stacks, and inspect detailed commit diffs directly in their editor.

## What Changes

- Create `nix/home-manager/editors/nvim/lua/plugins/blame.lua` to configure `FabijanZulj/blame.nvim`.
- Bind the toggle command to `<leader>gb` for easy, logical access.

## Capabilities

### New Capabilities

- `nvim-git-blame`: Interactive fugitive-style visual Git blame sidebar in Neovim.

### Modified Capabilities

<!-- None -->

## Impact

- Adds `:BlameToggle` and `<leader>gb` mapping to Neovim (loaded via Home Manager).
