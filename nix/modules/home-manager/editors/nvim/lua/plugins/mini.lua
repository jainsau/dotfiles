return {
  -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Autohighlight word under cursor
    require('mini.cursorword').setup({})

    -- Functionality to work with 'paired' characters conditional on cursor's
    -- neighborhood (two characters to its left and right).
    require('mini.pairs').setup({})

    -- Mappings and Lua functions that modify arguments (regions inside brackets
    -- between allowed separators) under cursor.
    require('mini.splitjoin').setup({})

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Show all listed buffers in readable way with minimal total width.
    require('mini.tabline').setup({})
  end,
}
