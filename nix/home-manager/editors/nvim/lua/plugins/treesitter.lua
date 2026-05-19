return {
  -- Configure Treesitter
  -- See `:help nvim-treesitter`
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  config = function()
    require('nvim-treesitter').setup({
      ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query' },
    })
  end,
}
