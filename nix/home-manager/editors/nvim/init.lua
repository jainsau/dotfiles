-- === NEOVIM MAIN INIT ===
-- Set <space> as the leader key
-- NOTE: Must happen before lazy (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if nerd font is installed
vim.g.have_nerd_font = true

-- Suppress treesitter query errors from built-in ftplugins
-- (Neovim 0.12 bundled queries expect a newer Lua parser grammar)
local _ts_start = vim.treesitter.start
vim.treesitter.start = function(...)
  local ok, err = pcall(_ts_start, ...)
  if not ok and not err:match('Query error') then
    error(err)
  end
end

require 'core.autocmds' -- autocommands
require 'core.config'   -- main config loader

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
