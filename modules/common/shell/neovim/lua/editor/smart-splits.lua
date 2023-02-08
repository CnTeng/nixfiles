return {
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  keys = {
    { "<A-r>", function() require("smart-splits").start_resize_mode() end },
    { "<A-h>", function() require("smart-splits").resize_left() end },
    { "<A-j>", function() require("smart-splits").resize_down() end },
    { "<A-k>", function() require("smart-splits").resize_up() end },
    { "<A-l>", function() require("smart-splits").resize_right() end },
    -- Better window navigation
    { "<C-h>", function() require("smart-splits").move_cursor_left() end },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end },
  },
  opts = {
    resize_mode = {
      silent = true,
      hooks = {
        on_enter = function() vim.notify "Enter resize mode" end,
        on_leave = function() vim.notify "Exit resize mode" end,
      },
    },
  },
}
