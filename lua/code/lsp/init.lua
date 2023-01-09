local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	vim.notify("lspconfig not found!", "error")
	return
end

require "code.lsp.lsp-installer"
require("code.lsp.handlers").setup()
require "code.lsp.null-ls"
