return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "famiu/bufdelete.nvim",
    },
    event = "BufEnter",
    init = function() vim.opt.mousemoveevent = true end, -- require for hover
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>c", "<cmd>bdelete<cr>", desc = "Close buffer" },
      { "<leader>bc", "<cmd>bdelete<cr>", desc = "Close buffer" },
      { "<leader>bC", function() require("bufdelete").bufdelete(0, false) end, desc = "Close buffer (keep layout)" },
      { "<leader>bh", "<cmd>BufferLineMovePrev<cr>", silent = true, desc = "Move buffer Left" },
      { "<leader>bl", "<cmd>BufferLineMoveNext<cr>", silent = true, desc = "Move buffer Right" },
    },
    opts = function()
      return {
        options = {
          tab_size = 20,
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
  },
}
