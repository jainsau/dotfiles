local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end


lspconfig.pylsp.setup{}
lspconfig.yamlls.setup{
  settings = {
    yaml = {
	  schemas = { kubernetes = "globPattern" },
	}
  }
}
