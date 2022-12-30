local add = require("utils.plugin").add

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

-- Startup
add {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function() require "ui.alpha" end,
}

-- Bufferline
add {
	"akinsho/bufferline.nvim",
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
	"catppuccin/nvim",
	name = "catppuccin",
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
