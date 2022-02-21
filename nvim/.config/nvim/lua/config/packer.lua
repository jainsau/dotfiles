
init = require("packer").init
util = require("packer.util")

init({
				compile_path = util.join_paths(vim.fn.stdpath('data'), 'plugin', 'packer_compiled.lua'), 
				display = { open_fn = function() return util.float{} end, },
})

