return {
  "kylechui/nvim-surround",
  -- keys = {
  --   { "<C-g>z", mode = "i", desc = "Add a surrounding pair around the cursor (insert mode)" },
  --   { "<C-g>Z", mode = "i", desc = "Add a surrounding pair around the cursor, on new lines (insert mode)" },
  --   { "gz", desc = "Add a surrounding pair around a motion (normal mode)" },
  --   { "gzs", desc = "Add a surrounding pair around the current line (normal mode)" },
  --   { "gZ", desc = "Add a surrounding pair around a motion, on new lines (normal mode)" },
  --   { "gZs", desc = "Add a surrounding pair around the current line, on new lines (normal mode)" },
  --   { "gz", mode = "x", desc = "Add a surrounding pair around a visual selection" },
  --   { "gZ", mode = "x", desc = "Add a surrounding pair around a visual selection, on new lines" },
  --   { "gzd", desc = "Delete a surrounding pair" },
  --   { "gzc", desc = "Change a surrounding pair" },
  -- },
  opts = {
    keymaps = {
      insert = "<C-g>z",
      insert_line = "<C-g>Z",
      normal = "gz",
      normal_cur = "gzs",
      normal_line = "gZ",
      normal_cur_line = "gZs",
      visual = "gz",
      visual_line = "gZ",
      delete = "gzd",
      change = "gzc",
    },
  },
}
