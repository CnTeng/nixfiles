return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v2.x",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer" },
  },
  init = function() vim.g.neo_tree_remove_legacy_commands = 1 end,
  opts = {
    close_if_last_window = true,
    source_selector = {
      winbar = true,
      statusline = false,
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
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["w"] = false,
        ["a"] = { "add", config = { show_path = "relative" } },
        ["H"] = "prev_source",
        ["L"] = "next_source",
      },
    },
    filesystem = {
      follow_current_file = true,
      use_libuv_file_watcher = true,
      window = {
        mappings = { ["h"] = "toggle_hidden" },
      },
    },
  },
}
