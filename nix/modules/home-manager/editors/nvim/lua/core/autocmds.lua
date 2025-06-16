-- This file is automatically loaded by lazyvim.config.init.

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('YankHighLight'),
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = '*',
})
