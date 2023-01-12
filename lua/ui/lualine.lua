local hide_in_width = function() return vim.fn.winwidth(0) > 80 end

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local mode = {
	"mode",
	fmt = function(str) return "-- " .. str .. " --" end,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " },
}

local encoding = {
	"encoding",
	cond = hide_in_width,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local progress = {
	"progress",
	fmt = function() return "%P/%L" end,
}

-- TODO:add support for lazy
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			icons_enabled = true,
			theme = "catppuccin",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { "alpha", "neo-tree" },
			always_divide_middle = true,
			globalstatus = true,
		},
		sections = {
			lualine_a = { branch, diagnostics },
			lualine_b = { mode },
			lualine_c = {},
			lualine_x = { diff, encoding, filetype },
			lualine_y = { "location" },
			lualine_z = { progress },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
	},
}
