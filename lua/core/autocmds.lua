local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("FileType", {
	desc = "Unlist quickfist buffers",
	group = augroup("unlist_quickfist", { clear = true }),
	pattern = { "qf", "help", "man", "notify", "lspinfo" },
	callback = function() vim.opt_local.buflisted = false end,
})

autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = augroup("highlightyank", { clear = true }),
	pattern = "*",
	callback = function() vim.highlight.on_yank() end,
})

autocmd("User", {
	desc = "Disable status and tablines for alpha",
	group = augroup("alpha_settings", { clear = true }),
	pattern = "AlphaReady",
	callback = function()
		local prev_showtabline = vim.opt.showtabline
		vim.opt.showtabline = 0
		vim.opt_local.winbar = nil
		autocmd("BufUnload", {
			pattern = "<buffer>",
			callback = function() vim.opt.showtabline = prev_showtabline end,
		})
	end,
})
