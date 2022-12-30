local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	vim.notify("cmp_nvim_lsp not found!", "error")
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = true, -- disable virtual text
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	local function extend(desc) return vim.tbl_deep_extend("force", { desc = desc }, opts) end
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", extend "Hover current symbol details")
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", extend "Go declaration")
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", extend "Go definition")
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", extend "Go implementation")
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", extend "Go references")
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", extend "Hover diagnostics")
	keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", extend "LSP info")
	keymap(bufnr, "n", "<leader>lI", "<cmd>Mason<cr>", extend "Installer info")
	keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", extend "Format code")
	keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", extend "Code action")
	keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", extend "Rename current symbol")
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", extend "Signature help")
	keymap(bufnr, "n", "<leader>lL", "<cmd>lua vim.lsp.codelens.run()<CR>", extend "CodeLens action")
	keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", extend "Next diagnostic")
	keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", extend "Previous diagnostic")
	keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", extend "List diagnostic")
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then client.server_capabilities.documentFormattingProvider = false end

	if client.name == "sumneko_lua" then client.server_capabilities.documentFormattingProvider = false end

	lsp_keymaps(bufnr)
	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		vim.notify("illuminate not found!", "error")
		return
	end
	illuminate.on_attach(client)
end

return M
