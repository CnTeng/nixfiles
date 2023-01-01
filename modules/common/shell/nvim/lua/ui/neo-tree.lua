local plugin = require "utils.plugin"

local neo_tree = plugin.pcall "neo-tree"
if not neo_tree then return end

neo_tree.setup {
	close_if_last_window = true,
	enable_git_status = true,
	enable_diagnostics = false,
	source_selector = {
		winbar = false,
		statusline = true,
		content_layout = "center",
	},
	default_component_configs = {
		indent = { padding = 0 },
	},
	window = {
		width = 30,
		mappings = {
			["<space>"] = false,
			["<2-LeftMouse>"] = "open",
			["<cr>"] = "open",
			["o"] = "open",
			-- ["O"]
			["<esc>"] = "revert_preview",
			["P"] = { "toggle_preview", config = { use_float = true } },
			["S"] = "open_split",
			["s"] = "open_vsplit",
			["t"] = "open_tabnew",
			-- ["w"] = "open_with_window_picker",
			["w"] = false,
			["C"] = "close_node",
			["z"] = "close_all_nodes",
			["Z"] = "expand_all_nodes",
			["a"] = {
				"add",
				config = {
					show_path = "relative", -- "none", "relative", "absolute"
				},
			},
			["A"] = "add_directory",
			["d"] = "delete",
			["r"] = "rename",
			["y"] = "copy_to_clipboard",
			["x"] = "cut_to_clipboard",
			["p"] = "paste_from_clipboard",
			["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
			-- ["c"] = {
			--  "copy",
			--  config = {
			--    show_path = "none" -- "none", "relative", "absolute"
			--  }
			--}
			["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
			["q"] = "close_window",
			["R"] = "refresh",
			["?"] = "show_help",
			["H"] = "prev_source",
			["L"] = "next_source",
		},
	},
	filesystem = {
		follow_current_file = true,
		hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
		-- in whatever position is specified in window.position
		-- "open_current",  -- netrw disabled, opening a directory opens within the
		-- window like netrw would, regardless of window.position
		-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
		use_libuv_file_watcher = true,
		window = {
			mappings = {
				["<bs>"] = "navigate_up",
				["."] = "set_root",
				["h"] = "toggle_hidden",
				["/"] = "fuzzy_finder",
				["D"] = "fuzzy_finder_directory",
				["f"] = "filter_on_submit",
				["<c-x>"] = "clear_filter",
				["[g"] = "prev_git_modified",
				["]g"] = "next_git_modified",
			},
		},
	},
	buffers = {
		follow_current_file = true, -- This will find and focus the file in the active buffer every
		-- time the current file is changed while the tree is open.
		group_empty_dirs = true, -- when true, empty folders will be grouped together
		show_unloaded = true,
		window = {
			mappings = {
				["bd"] = "buffer_delete",
				["<bs>"] = "navigate_up",
				["."] = "set_root",
			},
		},
	},
	git_status = {
		window = {
			position = "float",
			mappings = {
				["A"] = "git_add_all",
				["gu"] = "git_unstage_file",
				["ga"] = "git_add_file",
				["gr"] = "git_revert_file",
				["gc"] = "git_commit",
				["gp"] = "git_push",
				["gg"] = "git_commit_and_push",
			},
		},
	},
}
