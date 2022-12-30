local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	vim.notify("null-ls not found!", "error")
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
	debug = false,
	sources = {
		-- formatter
		formatting.prettier.with {
			extra_filetypes = { "toml" },
			extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
		},
		formatting.stylua,
		formatting.black.with { extra_args = { "--fast" } },
		formatting.golines,
		formatting.clang_format,
		diagnostics.flake8,
	},
}
