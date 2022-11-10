vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
	vim.notify("catppuccin not found!", "error")
	return
end

local ucolors = require "catppuccin.utils.colors"
local cp = require("catppuccin.palettes").get_palette()
catppuccin.setup {
	highlight_overrides = {
		all = {
			QuickFixLine = { bg = ucolors.darken(cp.blue, 0.36), style = { "bold" } },
			Visual = { bg = ucolors.darken(cp.blue, 0.36), style = { "bold" } },
			VisualNOS = { bg = ucolors.darken(cp.blue, 0.36), style = { "bold" } },
		},
	},
  styles = {
		comments = { "italic" },
		conditionals = {},
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	integrations = {
		gitsigns = true,
		cmp = true,
		notify = true,
		nvimtree = true,
		treesitter_context = true,
		treesitter = true,
		telescope = true,
		which_key = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = false,
		},
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
		},
	},
}

vim.cmd [[colorscheme catppuccin]]
