local keymap = vim.api.nvim_set_keymap
local opts = {noremap=true, silent=true}
local term_opts = {silent = true}


-- Remap space as the leader key
keymap("n", "<Space>", "<NOP>", opts)
vim.g.mapleader = " "

-- Mode References
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Splitting windows
keymap("n", "<leader><Bslash>", "<C-w>v", opts)
keymap("n", "<leader>-", "<C-w>s", opts)

-- Better window navigation
keymap("n", "<leader><Left>", "<C-w>h", opts)
keymap("n", "<leader><Down>", "<C-w>j", opts)
keymap("n", "<leader><Up>", "<C-w>k", opts)
keymap("n", "<leader><Right>", "<C-w>l", opts)

-- Open current window in a new tab
keymap("n", "<leader>t", "<C-w>T", opts)

-- Close current window 
keymap("n", "<leader>c", "<C-w>c", opts)

-- Better tab navigation
keymap("n", "<leader>n", "gt", opts)
keymap("n", "<leader>N", "gT", opts)

-- Resize with arrows
keymap("n", "<M-Up>", ":resize -2<CR>", opts)
keymap("n", "<M-Down>", ":resize +2<CR>", opts)
keymap("n", "<M-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<M-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<leader>h", ":bprevious<CR>", opts)
keymap("n", "<leader>l", ":bnext<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<M-j>", ":m .+1<CR>==", opts)
keymap("v", "<M-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "<M-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<M-k>", ":move '<-2<CR>gv-gv", opts)

-- Nvimtree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
