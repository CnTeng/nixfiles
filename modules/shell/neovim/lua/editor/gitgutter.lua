return {
  "airblade/vim-gitgutter",
  event = "VeryLazy",
  init = function()
    vim.g.gitgutter_sign_added = "+"
    vim.g.gitgutter_sign_modified = "~"
    vim.g.gitgutter_sign_removed = "_"
    vim.g.gitgutter_sign_removed_first_line = "‾"
    vim.g.gitgutter_sign_removed_above_and_below = "-"
    vim.g.gitgutter_sign_modified_removed = "~"

    vim.g.gitgutter_preview_win_floating = 1

    vim.g.gitgutter_map_keys = 0
  end,
  keys = {
    { "]h", "<cmd>GitGutterNextHunk<cr>", desc = "Next hunk" },
    { "[h", "<cmd>GitGutterPrevHunk<cr>", desc = "Previous hunk" },
    { "<leader>gf", "<cmd>GitGutterQuickFixCurrentFile | copen<cr>", desc = "QuickFix hunks (current file)" },
    { "<leader>gF", "<cmd>GitGutterQuickFix | copen<cr>", desc = "QuickFix hunks (all files)" },
    { "<leader>gp", "<cmd>GitGutterPreviewHunk<cr>", desc = "Preview hunk" },
    { "<leader>gs", "<cmd>GitGutterStageHunk<cr>", desc = "Stage hunk" },
    { "<leader>gu", "<cmd>GitGutterUndoHunk<cr>", desc = "Undo hunk" },
    { "<leader>gd", "<cmd>GitGutterDiffOrig<cr>", desc = "View diff" },
  },
}
