return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "vim",
      "lua",
      "json",
      "bash",
      "c",
      "cpp",
      "go",
      "nix",
      "python",
      "markdown",
      "markdown_inline",
      "org",
    },
    ignore_install = {},
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = { "markdown", "org" },
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
      enable = false,
      disable = {},
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  },
  config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
}
