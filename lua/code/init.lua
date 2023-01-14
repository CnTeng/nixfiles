local add = require("utils.plugin").add

-- Built-in LSP
add { "neovim/nvim-lspconfig" }

-- Package Manager

-- LSP manager

-- Formatting and linting
add {
	"jose-elias-alvarez/null-ls.nvim",
	--[[ config = function() require "configs.lsp.null-ls" end, ]]
}

add {
	"jayp0521/mason-null-ls.nvim",
	--[[ config = function() require "configs.mason-null-ls" end, ]]
}

-- [[DAP]]
add {
	"mfussenegger/nvim-dap",
	config = function() require "code.dap" end,
}
add { "rcarriga/nvim-dap-ui" }

-- [[Markdown]]
add {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	init = function() vim.g.mkdp_filetypes = { "markdown" } end,
	ft = { "markdown" },
}
