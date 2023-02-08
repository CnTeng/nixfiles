return {
  "akinsho/bufferline.nvim",
  event = "BufEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "famiu/bufdelete.nvim",
  },
  init = function() vim.opt.mousemoveevent = true end, -- Require for hover
  keys = {
    { "[b", "<cmd>bprevious<cr>", desc = "Previous buffer" },
    { "]b", "<cmd>bnext<cr>", desc = "Next buffer" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "<leader>c", function() require("bufdelete").bufdelete(0, false) end, desc = "Close buffer" },
    { "<leader>bc", function() require("bufdelete").bufdelete(0, false) end, desc = "Close buffer" },
    { "<leader>bC", "<cmd>bdelete<cr>", desc = "Close buffer (without layout)" },
    { "<leader>bh", "<cmd>BufferLineMovePrev<cr>", silent = true, desc = "Move buffer Left" },
    { "<leader>bl", "<cmd>BufferLineMoveNext<cr>", silent = true, desc = "Move buffer Right" },
  },
  opts = function()
    return {
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
        enforce_regular_tabs = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
      highlights = require("catppuccin.groups.integrations.bufferline").get {
        styles = { "bold" },
      },
    }
  end,
}
