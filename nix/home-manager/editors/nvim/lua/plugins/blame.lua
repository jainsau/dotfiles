return {
  {
    "FabijanZulj/blame.nvim",
    cmd = { "BlameToggle" },
    keys = {
      { "<leader>gb", "<cmd>BlameToggle<cr>", desc = "[G]it [B]lame" },
    },
    config = function()
      require("blame").setup({
        date_format = "%Y-%m-%d",
        virtual_style = "right_align",
      })
    end,
  },
}
