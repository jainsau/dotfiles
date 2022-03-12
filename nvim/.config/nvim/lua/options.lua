local o = vim.opt
local wo = vim.wo
local fn = vim.fn

o.clipboard = "unnamedplus"		-- allows nvim to access the system keyboard
o.mouse = "a"									-- allows the mouse to be used with nvim
o.number = true								-- show current line number
o.relativenumber = true				-- set relative numbered lines
o.tabstop = 2									-- insert 2 spaces for a tab
