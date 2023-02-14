return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "debugloop/telescope-undo.nvim" },
  },
  keys = {
    -- Buffer
    { "<leader>bs", function() require("telescope.builtin").buffers() end, desc = "Swicth buffer" },
    -- File
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    -- Search
    { "<leader>sb", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Buffer" },
    { "<leader>sc", function() require("telescope.builtin").commands() end, desc = "Commands" },
    { "<leader>sC", function() require("telescope.builtin").command_history() end, desc = "Command History" },
    { "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "Help pages" },
    { "<leader>sH", function() require("telescope.builtin").highlights() end, desc = "Highlight groups" },
    { "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Key maps" },
    { "<leader>sm", function() require("telescope.builtin").man_pages() end, desc = "Man pages" },
    { "<leader>sn", function() require("telescope").extensions.notify.notify() end, desc = "Notifications" },
    { "<leader>so", function() require("telescope.builtin").vim_options() end, desc = "Options" },
    { "<leader>sr", function() require("telescope.builtin").registers() end, desc = "Registers" },
    { "<leader>su", function() require("telescope.builtin").grep_string() end, desc = "Current word" },
    { "<leader>sU", function() require("telescope").extensions.undo.undo() end, desc = "Undo" },
    { "<leader>sw", function() require("telescope.builtin").live_grep() end, desc = "Word" },
    -- Git
    { "<leader>gt", function() require("telescope.builtin").git_status() end, desc = "Git status" },
    { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
    { "<leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
  },
  opts = function()
    local actions = require "telescope.actions"

    return {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        path_display = { "smart" },

        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,

            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },

          n = {
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          find_command = { "fd", "-H", "-I" }, -- No hidden & ignore
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        undo = {},
      },
    }
  end,
  config = function(_, opts)
    local telescope = require "telescope"

    telescope.setup(opts)

    telescope.load_extension "ui-select"
    telescope.load_extension "fzf"
    telescope.load_extension "undo"
  end,
}
