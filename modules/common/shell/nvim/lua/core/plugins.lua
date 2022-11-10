-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
	print "Installing packer close and reopen Neovim..."
	vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	vim.notify("packer not found!", "error")
	return
end

-- Have packer use a popup window
packer.init {
	display = {
		open_fn = function() return require("packer.util").float { border = "rounded" } end,
	},
}

-- Install your plugins here
return packer.startup(function(use)
	-- [[Core]]
	-- Plugin manager
	use { "wbthomason/packer.nvim" }

	-- Optimiser
	use { "lewis6991/impatient.nvim" }

	-- Neovim Lua Development
	use { "nvim-lua/plenary.nvim" }

	-- Fuzzy finder
	use {
		"nvim-telescope/telescope.nvim",
		config = function() require "configs.telescope" end,
	}

	-- Fuzzy finder plugins
	use {
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make",
	}
	use { "nvim-telescope/telescope-ui-select.nvim" }

	-- Icons
	use { "kyazdani42/nvim-web-devicons" }

	-- Nvim-Tree
	use {
		"kyazdani42/nvim-tree.lua",
		config = function() require "configs.nvim-tree" end,
	}

	-- Terminal integration
	use {
		"akinsho/toggleterm.nvim",
		config = function() require "configs.toggleterm" end,
	}

	-- Keymaps popup
	use {
		"folke/which-key.nvim",
		config = function() require "configs.which-key" end,
	}

	-- [[UI]]
	-- Startup
	use {
		"goolord/alpha-nvim",
		config = function() require "configs.alpha" end,
	}

	-- Bufferline
	use {
		"akinsho/bufferline.nvim",
		config = function() require "configs.bufferline" end,
	}

	-- Better buffer closing
	use { "famiu/bufdelete.nvim" }

	-- Statusline
	use {
		"nvim-lualine/lualine.nvim",
		config = function() require "configs.lualine" end,
	}

	-- Colorschemes
	use { "folke/tokyonight.nvim" }
	use {
		"catppuccin/nvim",
		as = "catppuccin",
	}

	-- Notification Enhancer
	use {
		"rcarriga/nvim-notify",
		config = function() require "configs.notify" end,
	}

	-- Git integration
	use {
		"lewis6991/gitsigns.nvim",
		config = function() require "configs.gitsigns" end,
	}

	-- [[Snippet]]
	-- Snippet engine
	use { "L3MON4D3/LuaSnip" }

	-- Snippet collection
	use { "rafamadriz/friendly-snippets" }

	-- [[CMP]]
	-- Completion engine
	use {
		"hrsh7th/nvim-cmp",
		config = function() require "configs.cmp" end,
	}

	-- Buffer completion source
	use {
		"hrsh7th/cmp-buffer",
		after = "nvim-cmp",
	}

	-- Path completion source
	use {
		"hrsh7th/cmp-path",
		after = "nvim-cmp",
	}

	-- Cmdline completion source
	use {
		"hrsh7th/cmp-cmdline",
		after = "nvim-cmp",
	}

	-- LSP completion source
	use {
		"hrsh7th/cmp-nvim-lsp",
		after = "nvim-cmp",
	}

	-- Lua completion source
	use {
		"hrsh7th/cmp-nvim-lua",
		after = "nvim-cmp",
	}

	-- Snippet completion source
	use {
		"saadparwaiz1/cmp_luasnip",
		after = "nvim-cmp",
	}

	-- [[LSP]]
	-- Built-in LSP
	use { "neovim/nvim-lspconfig" }

	-- Package Manager
	use {
		"williamboman/mason.nvim",
		config = function() require "configs.mason" end,
	}

	use {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		after = "mason.nvim",
		config = function() require "configs.mason-tool-installer" end,
	}

	-- LSP manager
	use {
		"williamboman/mason-lspconfig.nvim",
		after = { "mason.nvim", "nvim-lspconfig" },
		config = function() require "configs.lsp" end,
	}

	-- Formatting and linting
	use {
		"jose-elias-alvarez/null-ls.nvim",
		config = function() require "configs.lsp.null-ls" end,
	}


  use {
    "jayp0521/mason-null-ls.nvim",
    config = function() require "configs.mason-null-ls" end,
  }

	-- Cursorline
	use { "RRethy/vim-illuminate" }

	-- [[Code]]
	-- Syntax highlighting
	use {
		"nvim-treesitter/nvim-treesitter",
		config = function() require "configs.treesitter" end,
	}

	-- Comment
	use {
		"numToStr/Comment.nvim",
		config = function() require "configs.comment" end,
	}
	use {
		"folke/todo-comments.nvim",
		config = function() require "configs.todo-comments" end,
	}

	-- Context based commenting
	use { "JoosepAlviste/nvim-ts-context-commentstring" }

	-- Autopairs
	use {
		"windwp/nvim-autopairs",
		config = function() require "configs.autopairs" end,
	}

	-- Indentation
	use {
		"lukas-reineke/indent-blankline.nvim",
		config = function() require "configs.indent-line" end,
	}

	-- [[DAP]]
	use {
		"mfussenegger/nvim-dap",
		config = function() require "configs.dap" end,
	}
	use { "rcarriga/nvim-dap-ui" }

	-- [[Markdown]]
	use {
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
		ft = { "markdown" },
	}

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then require("packer").sync() end
end)
