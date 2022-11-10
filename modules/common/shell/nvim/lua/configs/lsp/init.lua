local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	vim.notify("lspconfig not found!", "error")
	return
end

require "configs.lsp.lsp-installer"
require("configs.lsp.handlers").setup()
require "configs.lsp.null-ls"
