local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	vim.notify("treesitter not found!", "error")
	return
end

treesitter.setup {
	ensure_installed = {
		"json",
		"lua",
		"vim",
		"c",
		"cpp",
		"go",
		"python",
		"bash",
		"markdown",
	},
	ignore_install = {},
	highlight = {
		enable = true,
		disable = {},
		additional_vim_regex_highlighting = false,
	},
	rainbow = {
		enable = true,
		disable = { "html" },
		extended_mode = false,
		max_file_lines = nil,
	},
	autopairs = { enable = true },
	incremental_selection = { enable = true },
	indent = {
		enable = true,
		disable = {},
	},
}
