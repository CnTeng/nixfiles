return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown", "org" },
      },
      incremental_selection = { enable = true },
      indent = { enable = false },
      rainbow = {
        enable = true,
        disable = { "html" },
      },
      autotag = { enable = true },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },
}
