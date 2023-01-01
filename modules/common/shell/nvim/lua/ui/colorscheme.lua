local plugin = require "utils.plugin"

local catppuccin = plugin.pcall "catppuccin"
if not catppuccin then return end

local ucolors = require "catppuccin.utils.colors"
local cp = require("catppuccin.palettes").get_palette()

catppuccin.setup {
	flavour = "macchiato", -- latte, frappe, macchiato, mocha
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
	highlight_overrides = {
		all = {
			QuickFixLine = {
				bg = ucolors.darken(cp.blue, 0.36),
				style = { "bold" },
			},
			Visual = {
				bg = ucolors.darken(cp.blue, 0.36),
				style = { "bold" },
			},
			VisualNOS = {
				bg = ucolors.darken(cp.blue, 0.36),
				style = { "bold" },
			},
		},
	},
	integrations = {
		gitsigns = true,
		mason = true,
		neotree = true,
		cmp = true,
		notify = true,
		treesitter_context = true,
		treesitter = true,
		telescope = true,
		illuminate = true,
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

vim.cmd.colorscheme "catppuccin"
