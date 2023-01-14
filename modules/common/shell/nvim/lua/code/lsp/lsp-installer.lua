local servers = {
	"jsonls",
	"sumneko_lua",
	"clangd",
	"gopls",
	"pyright",
	"nil_ls",
}

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	vim.notify("lspconfig not found!", "error")
	return
end

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("code.lsp.handlers").on_attach,
		capabilities = require("code.lsp.handlers").capabilities,
	}

	local has_custom_opts, server_custom_opts = pcall(require, "code.lsp.settings." .. server)
	if has_custom_opts then opts = vim.tbl_deep_extend("force", opts, server_custom_opts) end

	lspconfig[server].setup(opts)
end
