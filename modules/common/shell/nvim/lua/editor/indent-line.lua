return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    opts = {
      char = "▏",
      context_char = "▎",
      filetype_exclude = {
        "help",
        "man",
        "checkhealth",
        "lazy",
        "alpha",
        "dashboard",
        "neo-tree",
        "aerial",
        "lspinfo",
      },
      use_treesitter = true,
      show_current_context = true,
      show_current_context_start = true,
      show_trailing_blankline_indent = false,
    },
  },
}
