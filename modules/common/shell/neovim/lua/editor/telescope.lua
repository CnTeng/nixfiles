-- TODO:finsh telescope config
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  keys = {
    -- buffer
    { "<leader>bs", function() require("telescope.builtin").buffers() end, desc = "Swicth buffer" },
    -- file
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    {
      "<leader>fF",
      function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
      desc = "Find files (no hidden)",
    },
    -- search
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
    { "<leader>sw", function() require("telescope.builtin").live_grep() end, desc = "Word" },
    {
      "<leader>sW",
      function()
        require("telescope.builtin").live_grep {
          additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
        }
      end,
      desc = "Word (no hidden)",
    },

    -- git
    { "<leader>gt", function() require("telescope.builtin").git_status() end, desc = "Git status" },
    { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
    { "<leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
  },
  opts = function()
    local actions = require "telescope.actions"

    local telescope = require "telescope"
    telescope.load_extension "fzf"
    telescope.load_extension "ui-select"

    return {
      defaults = {
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        prompt_prefix = "   ",
        selection_caret = "  ",
        path_display = { "smart" },

        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,

            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<C-c>"] = actions.close,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          },

          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

            ["?"] = actions.which_key,
          },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          -- find_command = { "find", "-type", "f" },
          find_command = { "fd", "-H", "-I" }, -- "-H" search hidden files, "-I" do not respect to gitignore
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            -- even more opts
          },
        },
      },
    }
  end,
}
