local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	vim.notify("which-key not found!", "error")
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<C-d>", -- binding to scroll down inside the popup
		scroll_up = "<C-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
	mode = "v", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	-- Standard Operations
	["w"] = { "<cmd>w<CR>", "Save" },
	["q"] = { "<cmd>q<CR>", "Quit" },
	["h"] = { "<cmd>nohlsearch<CR>", "No highlight" },

	-- Packer
	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

	-- Alpha
	["a"] = { "<cmd>Alpha<cr>", "Alpha" },

	-- Bufdelete
	["c"] = { "<cmd>Bdelete<cr>", "Close buffer" },

	-- Neo-Tree
	["e"] = { "<cmd>Neotree toggle<cr>", "Explorer" },
	["o"] = { "<cmd>Neotree focus<cr>", "Explorer" },

	-- Comment
	["/"] = { function() require("Comment.api").toggle.linewise.current() end, "Comment line" },

	-- Recent file
	["r"] = { function() require("telescope.builtin").oldfiles() end, "Recent file" },

	-- Telescope
	f = {
		name = "Find",
		f = { function() require("telescope.builtin").find_files() end, "Files" },
		F = {
			function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
			"Files in all files",
		},
		w = { function() require("telescope.builtin").live_grep() end, "Words" },
		W = {
			function()
				require("telescope.builtin").live_grep {
					additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
				}
			end,
			"Words in all files",
		},
		u = { function() require("telescope.builtin").grep_string() end, "Word under cursor" },
		b = { function() require("telescope.builtin").buffers() end, "Buffers" },
		h = { function() require("telescope.builtin").help_tags() end, "Help" },
		m = { function() require("telescope.builtin").marks() end, "Marks" },
		-- Unavailable in windows, because powershell prefer man command alias of Get-Help
		M = { function() require("telescope.builtin").man_pages() end, "Man" },
		n = { function() require("telescope").extensions.notify.notify() end, "Notifications" },
		r = { function() require("telescope.builtin").registers() end, "Registers" },
		k = { function() require("telescope.builtin").keymaps() end, "Keymaps" },
		c = { function() require("telescope.builtin").commands() end, "Commands" },
	},

	-- Gitsigns
	g = {
		name = "Git",
		j = { function() require("gitsigns").next_hunk() end, "Next hunk" },
		k = { function() require("gitsigns").prev_hunk() end, "Prev hunk" },
		l = { function() require("gitsigns").blame_line() end, "View blame" },
		p = { function() require("gitsigns").preview_hunk() end, "Preview hunk" },
		r = { function() require("gitsigns").reset_hunk() end, "Reset hunk" },
		R = { function() require("gitsigns").reset_buffer() end, "Reset buffer" },
		s = { function() require("gitsigns").stage_hunk() end, "Stage hunk" },
		u = { function() require("gitsigns").undo_stage_hunk() end, "Unstage hunk" },
		d = { function() require("gitsigns").diffthis() end, "View diff" },
		t = { "<cmd>Telescope git_status<cr>", "Status" },
		b = { "<cmd>Telescope git_branches<cr>", "Branchs" },
		c = { "<cmd>Telescope git_commits<cr>", "Commits" },
	},

	l = {
		name = "LSP",
		i = { "<cmd>LspInfo<cr>", "LSP info" },
		I = { "<cmd>Mason<cr>", "Installer info" },
		f = { function() vim.lsp.buf.format() end, "Format code" },
		a = { function() vim.lsp.buf.code_action() end, "Code action" },
		r = { function() vim.lsp.buf.rename() end, "Rename current symbol" },
		s = { function() vim.lsp.buf.signature_help() end, "Signature help" },
		L = { function() vim.lsp.codelens.run() end, "CodeLens action" },
		j = { function() vim.lsp.diagnostic.goto_next() end, "Next diagnostic" },
		k = { function() vim.lsp.diagnostic.goto_prev() end, "Prev diagnostic" },
		l = { function() vim.lsp.diagnostic.set_loclist() end, "List diagnostic" },
		d = { function() require("telescope.builtin").diagnostics() end, "Search diagnostics" },
		R = { function() require("telescope.builtin").lsp_references() end, "Search references" },
	},

	t = {
		name = "Terminal",
		f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
		h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
		v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
	},
}

local vmappings = {
	["/"] = { "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", "Toggle comment line" },
	l = {
		name = "LSP",
		a = { function() vim.lsp.buf.range_code_action() end, "Range code action" },
		f = {
			function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)
				vim.lsp.buf.range_formatting()
			end,
			"Range format code",
		},
	},
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
