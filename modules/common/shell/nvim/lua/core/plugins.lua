local plugin = require "utils.plugin"
local add = plugin.add
plugin.init()
require "ui"
require "editor"
require "code"

-- Fuzzy finder
add {
	"nvim-telescope/telescope.nvim",
	config = function() require "core.telescope" end,
}

-- Fuzzy finder plugins
add {
	"nvim-telescope/telescope-fzf-native.nvim",
	build = "make",
}
add { "nvim-telescope/telescope-ui-select.nvim" }

-- Terminal integration
add {
	"akinsho/toggleterm.nvim",
	config = function() require "core.toggleterm" end,
}

add {
	"folke/which-key.nvim",
	config = function() require "core.which-key" end,
}


plugin.load()
