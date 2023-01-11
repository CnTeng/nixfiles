local add = require("utils.plugin").add

add {
	"NvChad/nvim-colorizer.lua",
	--[[ lazy = true, ]]
	config = function() require "editor.colorizer" end,
}

-- Snippet engine
add {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets" },
}

-- [[CMP]]
add {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function() require "editor.cmp" end,
}

-- Cursorline
add { "RRethy/vim-illuminate" }

-- [[Code]]
-- Syntax highlighting
add {
	"nvim-treesitter/nvim-treesitter",
	config = function() require "editor.treesitter" end,
}

-- Comment
add {
	"numToStr/Comment.nvim",
	config = function() require "editor.comment" end,
}
add {
	"folke/todo-comments.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function() require "editor.todo-comments" end,
}

-- Context based commenting
add { "JoosepAlviste/nvim-ts-context-commentstring" }

-- Autopairs
add {
	"windwp/nvim-autopairs",
	config = function() require "editor.autopairs" end,
}

-- Indentation
add {
	"lukas-reineke/indent-blankline.nvim",
	config = function() require "editor.indent-line" end,
}
