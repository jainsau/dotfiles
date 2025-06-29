-- === NEOVIM KEYMAPS ===
local map = function(mode, new, old, opts)
	opts = opts or {}

	vim.keymap.set(mode, new, old, opts)
end

-- Disable arrow keys in normal mode
map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Window navigation
-- `:help wincmd`
-- CTRL+<hjkl> to switch between windows
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- <leader>+<hjkl> to switch between buffers and tabs
map('n', '<leader>h', '<CMD>tabprevious<CR>', { desc = 'Move focus to the previous tab' })
map('n', '<leader>l', '<CMD>tabnext<CR>', { desc = 'Move focus to the next tab' })
map('n', '<leader>j', '<CMD>bprevious<CR>', { desc = 'Move focus to the previous buffer' })
map('n', '<leader>k', '<CMD>bnext<CR>', { desc = 'Move focus to the next buffer' })

-- Utility keybinds
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlight on pressing <Esc>' })

map('n', '<leader>t', '<C-w>T', { desc = 'Open current buffer in a new tab' })

map('n', '<leader>x', '<CMD>split<CR>', { desc = 'Create horizontal buffer split' })
map('n', '<leader>v', '<CMD>vsplit<CR>', { desc = 'Create vertical buffer split' })

map('n', '<leader>r', '<CMD>so %<CR>', { desc = 'Source current buffer' })

map('n', '<leader>d', '<CMD>bdelete %<CR>', { desc = '[D]elete current buffer' })
map('n', '<leader>c', '<C-w>c', { desc = '[C]lose current buffer' })

