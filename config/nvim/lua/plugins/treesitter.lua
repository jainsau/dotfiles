return {
  -- Configure Treesitter
  -- See `:help nvim-treesitter`
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    local config = require('nvim-treesitter.configs')
    config.setup({
      indent = { enable = true },
      incremental_selection = { enable = true },
      ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query' },     -- pre-install minimum required set
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] =  "@class.inner",
          },
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'v',
            ['@class.outer'] = '<c-v>',
          },
          include_surrounding_whitespace = true,
        },
--         move = {
--           enable = true,
--           set_jumps = true, -- whether to set jumps in the jumplist
--           goto_next_start = {
--             ["]m"] = "@function.outer",
--             ["]]"] = "@class.outer",
--           },
--           goto_next_end = {
--             ["]M"] = "@function.outer",
--             ["]["] = "@class.outer",
--           },
--           goto_previous_start = {
--             ["[m"] = "@function.outer",
--             ["[["] = "@class.outer",
--           },
--           goto_previous_end = {
--             ["[M"] = "@function.outer",
--             ["[]"] = "@class.outer",
--           },
--         },
      }
    })
  end,
}
