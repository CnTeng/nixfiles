return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  keys = {
    { "]h", function() require("gitsigns").next_hunk() end, desc = "Next hunk" },
    { "[h", function() require("gitsigns").prev_hunk() end, desc = "Previous hunk" },
    { "<leader>gl", function() require("gitsigns").blame_line() end, desc = "View blame" },
    { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
    { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
    { "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "Reset buffer" },
    { "<leader>gs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
    { "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage hunk" },
    { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "View diff" },
  },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "契" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    watch_gitdir = {
      enable = false,
    },
    current_line_blame = true,
    preview_config = {
      border = "none",
    },
  },
}
