local status_ok, configs = pcall(require, "nvim-autpairs")
if not status_ok then
	return
end

configs.setup {
}
