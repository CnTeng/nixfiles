local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	vim.notify("indent_blankline not found!", "error")
	return
end

indent_blankline.setup {
	buftype_exclude = {
		"nofile",
		"terminal",
	},
	filetype_exclude = {
		"help",
		"startify",
		"aerial",
		"alpha",
		"dashboard",
		"packer",
		"neogitstatus",
		"NvimTree",
		"neo-tree",
		"Trouble",
	},
	context_patterns = {
		"class",
		"return",
		"function",
		"method",
		"^if",
		"^while",
		"jsx_element",
		"^for",
		"^object",
		"^table",
		"block",
		"arguments",
		"if_statement",
		"else_clause",
		"jsx_element",
		"jsx_self_closing_element",
		"try_statement",
		"catch_clause",
		"import_statement",
		"operation_type",
	},
	indentLine_enabled = true,
	show_current_context = true,
	show_trailing_blankline_indent = false,
	show_first_indent_level = true,
	char = "▏",
	use_treesitter = true,
}
