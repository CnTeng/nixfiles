return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      icons_enabled = true,
      theme = "catppuccin",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "neo-tree" },
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str) return vim.fn.winwidth(0) > 80 and " " .. str .. " " or " " end,
          padding = 0,
        },
      },
      lualine_b = {
        { "branch", icon = "" },
        { "diff", colored = false, symbols = { added = " ", modified = " ", removed = " " } },
      },
      lualine_c = {
        { "diagnostics", sources = { "nvim_diagnostic" } },
      },
      lualine_x = {
        { require("lazy.status").updates, cond = require("lazy.status").has_updates },
        { "filetype", icon_only = true },
        "encoding",
      },
      lualine_y = {
        { "location", separator = " ", padding = { left = 1, right = 0 } },
        { "progress", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        {
          function() return vim.fn.winwidth(0) > 80 and "  " .. os.date "%R " or " " end,
          padding = 0,
        },
      },
    },
  },
}
