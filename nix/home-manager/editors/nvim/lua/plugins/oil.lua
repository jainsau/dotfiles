-- [[ Configure Oil ]]
-- See `:help Oil`

local oil_config = function()
  require('oil').setup {
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    experimental_watch_for_changes = true,
    view_options = {
      show_hidden = false,
    },
    keymaps = {
      ['+'] = 'actions.toggle_hidden',
    },
  }
end

return {
  'stevearc/oil.nvim',
  config = oil_config,
  opts = {},
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = { { '<leader>o', '<cmd>Oil<cr>', desc = '[O]pen Oil Buffer' } },
}
