local add = require("utils.plugin").add

add {
	"NvChad/nvim-colorizer.lua",
	--[[ lazy = true, ]]
	config = function() require "editor.colorizer" end,
}

-- Snippet engine
add { "L3MON4D3/LuaSnip" }

-- Snippet collection
add { "rafamadriz/friendly-snippets" }

-- [[CMP]]
-- Completion engine
add {
	"hrsh7th/nvim-cmp",
	config = function() require "editor.cmp" end,
}

-- Buffer completion source
add {
	"hrsh7th/cmp-buffer",
}

-- Path completion source
add {
	"hrsh7th/cmp-path",
}

-- Cmdline completion source
add {
	"hrsh7th/cmp-cmdline",
}

-- LSP completion source
add {
	"hrsh7th/cmp-nvim-lsp",
}

-- Lua completion source
add {
	"hrsh7th/cmp-nvim-lua",
}

-- Snippet completion source
add {
	"saadparwaiz1/cmp_luasnip",
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
