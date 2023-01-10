for _, source in ipairs {
	"core.options",
	"core.keymaps",
	"core.autocmds",
} do
	local status_ok, fault = pcall(require, source)
	if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

local add = require("utils.plugin").add

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

add {
	"s1n7ax/nvim-window-picker",
	config = function() require("window-picker").setup() end,
}
