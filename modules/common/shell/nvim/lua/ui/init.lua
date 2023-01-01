local add = require("utils.plugin").add

-- Startup
add {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function() require "ui.alpha" end,
}

add {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v2.x",
	module = "neo-tree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	init = function() vim.g.neo_tree_remove_legacy_commands = true end,
	config = function() require "ui.neo-tree" end,
}

-- Bufferline
add {
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function() require "ui.bufferline" end,
}
-- Better buffer closing
add { "famiu/bufdelete.nvim" }

-- Statusline
add {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function() require "ui.lualine" end,
}

-- Colorschemes
add {
	"CnTeng/catppuccin-nvim",
	commit = "main",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function() require "ui.colorscheme" end,
}

-- Notification Enhancer
add {
	"rcarriga/nvim-notify",
	config = function() require "ui.notify" end,
}

-- Git integration
add {
	"lewis6991/gitsigns.nvim",
	config = function() require "ui.gitsigns" end,
}

add {
	"utilyre/barbecue.nvim",
	branch = "dev", -- omit this if you only want stable updates
	dependencies = {
		"neovim/nvim-lspconfig",
		"smiteshp/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
	config = function() require "ui.barbecue" end,
}
