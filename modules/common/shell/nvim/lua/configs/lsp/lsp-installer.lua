local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	vim.notify("mason_lspconfig not found!", "error")
	return
end

local servers = {
	"jsonls",
	"sumneko_lua",
	"clangd",
	"gopls",
	"pyright",
	"rnix",
}

mason_lspconfig.setup {
	ensure_installed = servers,
	automatic_installation = true,
}

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	vim.notify("lspconfig not found!", "error")
	return
end

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("configs.lsp.handlers").on_attach,
		capabilities = require("configs.lsp.handlers").capabilities,
	}

	local has_custom_opts, server_custom_opts = pcall(require, "configs.lsp.settings." .. server)
	if has_custom_opts then opts = vim.tbl_deep_extend("force", opts, server_custom_opts) end

	lspconfig[server].setup(opts)
end
