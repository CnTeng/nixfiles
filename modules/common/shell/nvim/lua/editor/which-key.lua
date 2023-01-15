return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      key_labels = { ["<leader>"] = "SPC" },
    },
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      --[[   t = { ]]
      --[[     name = "Terminal", ]]
      --[[     f = { "<cmd>ToggleTerm direction=float<cr>", "Float" }, ]]
      --[[     h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" }, ]]
      --[[     v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" }, ]]
      --[[   }, ]]
      --[[ } ]]
      --[[]]

      local wk = require "which-key"
      wk.setup(opts)
      wk.register {
        mode = { "n", "v" },
        ["]"] = { name = "+Next" },
        ["["] = { name = "+Prev" },
        ["g"] = { name = "+Goto" },
        ["<leader>f"] = { name = "+Search" },
        ["<leader>g"] = { name = "+Git" },
        ["<leader>l"] = { name = "+LSP" },
        ["<leader>p"] = { name = "+Plugin" },
      }
    end,
  },
}
