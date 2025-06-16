-- Set <space> as the leader key
-- NOTE: Must happen before lazy (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if nerd font is installed
vim.g.have_nerd_font = true

require 'core.autocmds' -- autocommands
require 'core.config'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
