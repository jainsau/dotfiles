local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- Bootstrap Packer if not installed
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
			"git", 
			"clone", 
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
	})
	print("Installing Packer...close and reopen Neovim.")
	vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Autocommand that reloads neovim whenever we save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Expects the name of the config file
function load_config(name)
	local status_ok, config = require(string.format("configs/%s", name))
	if not status_ok then
		return
	else
		return config
	end
end

-- Define actual plugins list
return packer.startup(function(use)
	-- Common utilities
	use { 'wbthomason/packer.nvim', config=load_config("packer") }
	use { "nvim-lua/popup.nvim" } -- An implementation of the PopoAPI from vim in Neovim
	use { "nvim-lua/plenary.nvim" } -- Useful Lua functions used by lots of plugins
	use { "kyazdani42/nvim-web-devicons", config=load_config('web-devicons') } -- Adds devicons to NVim
    use { "kyazdani42/nvim-tree.lua", config=load_config("tree") } -- File explorer
	use { "numToStr/Comment.nvim", config=load_config('Comment') } -- Easily comment stuff
	use { "akinsho/bufferline.nvim", config=load_config("bufferline") }
	use { "akinsho/toggleterm.nvim", config=load_config("toggleterm") }
	use { "folke/which-key.nvim", config=load_config("which-key") }
	
	-- CMP
	use { "hrsh7th/nvim-cmp", } -- FIX
	use { "hrsh7th/cmp-buffer", } -- FIX
	use { "hrsh7th/cmp-path", } -- FIX
	use { "hrsh7th/cmp-cmdline", } -- FIX
	use { "saadparwaiz1/cmp_luasnip", } -- FIX
	use { "hrsh7th/cmp-nvim-lsp", } -- FIX
	use { "jose-elias-alvarez/null-ls.nvim", } --FIX
	use { "folke/trouble.nvim" } --FIX

	-- LSP
	use { "neovim/nvim-lspconfig", config=load_config("lsp") }
	use { "williamboman/nvim-lsp-installer", config=load_config("lsp") } -- FIX

	-- Telescope
	use { 'nvim-telescope/telescope.nvim' }

	-- Treesitter
	use { 'nvim-treesitter/nvim-treesitter', config=load_config("treesitter"), run=':TSUpdate' }
	use { 'p00f/nvim-ts-rainbow' } -- Rainbow parentheses for neovim using tree-sitter
	use { 'nvim-treesitter/playground' }

	-- Programming plugins
	-- Better to load these after CMP and TS as their configs may sometime depend on them -
	-- - in which case the first time setup will fail
	use { "windwp/nvim-autopairs", config=load_config('autopairs') } -- Integrates with both cmp and treesitter

	if PACKER_BOOTSTRAP then
		packer.sync()
	end

	end
)

