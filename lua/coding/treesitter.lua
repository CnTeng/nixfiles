return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  opts = {
    ensure_installed = {
      "json",
      "lua",
      "vim",
      "c",
      "cpp",
      "go",
      "python",
      "bash",
      "markdown",
      "markdown_inline",
      "nix",
    },
    ignore_install = {},
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = { "markdown" },
    },
    rainbow = {
      enable = true,
      disable = { "html" },
      extended_mode = false,
      max_file_lines = nil,
    },
    autopairs = { enable = true },
    incremental_selection = { enable = true },
    indent = {
      enable = true,
      disable = {},
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  },
  config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
}
