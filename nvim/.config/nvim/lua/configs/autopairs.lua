local status_ok, npairs = pcall(require, "nvim-autpairs")
if not status_ok then
	return
end

npairs.setup({
  check_ts = true,
  ts_config = {
    lua = {'string', 'source'}, -- It will not add a pair on that treesitter node
    python = {'string'},
    javascript = {'string', 'template_string'},
    java = false, -- Don't check Treesitter on Java
  },
  disable_filetype = { "TelescopePrompt", "vim", "spectre_panel" },
  fast_wrap = {
    map = "<M-e>",
		chars = { '{', '[', '(', '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
      offset = 0, -- Offset from pattern match
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'PmenuSel',
      highlight_grey='LineNr'
	},
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end
cmp.event:on("confim_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

