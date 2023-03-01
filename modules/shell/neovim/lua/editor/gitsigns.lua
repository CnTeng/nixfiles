return {
  -- "airblade/vim-gitgutter",
  -- event = "VeryLazy",
  -- init = function()
  --   vim.g.gitgutter_sign_added = "+"
  --   vim.g.gitgutter_sign_modified = "~"
  --   vim.g.gitgutter_sign_removed = "_"
  --   vim.g.gitgutter_sign_removed_first_line = "‾"
  --   vim.g.gitgutter_sign_removed_above_and_below = "-"
  --   vim.g.gitgutter_sign_modified_removed = "~"

  --   vim.g.gitgutter_preview_win_floating = 1

  --   vim.g.gitgutter_map_keys = 0
  -- end,
  -- keys = {
  --   { "]h", "<cmd>GitGutterNextHunk<cr>", desc = "Next hunk" },
  --   { "[h", "<cmd>GitGutterPrevHunk<cr>", desc = "Previous hunk" },
  --   { "<leader>gf", "<cmd>GitGutterQuickFixCurrentFile | copen<cr>", desc = "QuickFix hunks (current file)" },
  --   { "<leader>gF", "<cmd>GitGutterQuickFix | copen<cr>", desc = "QuickFix hunks (all files)" },
  --   { "<leader>gp", "<cmd>GitGutterPreviewHunk<cr>", desc = "Preview hunk" },
  --   { "<leader>gs", "<cmd>GitGutterStageHunk<cr>", desc = "Stage hunk" },
  --   { "<leader>gu", "<cmd>GitGutterUndoHunk<cr>", desc = "Undo hunk" },
  --   { "<leader>gd", "<cmd>GitGutterDiffOrig<cr>", desc = "View diff" },
  -- },
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
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "-" },
      untracked = { text = "~" },
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
