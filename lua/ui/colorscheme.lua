return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  opts = {
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    styles = {
      comments = { "italic" },
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    integrations = {
      fidget = true,
      gitsigns = true,
      leap = true,
      neotree = true,
      cmp = true,
      dap = {
        enabled = true,
        enable_ui = true,
      },
      notify = true,
      treesitter_context = true,
      treesitter = true,
      telescope = true,
      illuminate = true,
      which_key = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme "catppuccin"
  end,
}
