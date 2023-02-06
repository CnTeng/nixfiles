return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.timeout = true
    vim.opt.timeoutlen = 300
  end,
  opts = {
    plugins = { spelling = true },
    key_labels = { ["<leader>"] = "SPC" },
    register = {
      mode = { "n", "v" },
      ["]"] = { name = "+Next" },
      ["["] = { name = "+Prev" },
      ["g"] = { name = "+Goto" },
      ["<leader>b"] = { name = "+Buffer" },
      ["<leader>d"] = { name = "+Debugger" },
      ["<leader>f"] = { name = "+File" },
      ["<leader>g"] = { name = "+Git" },
      ["<leader>l"] = { name = "+LSP" },
      ["<leader>p"] = { name = "+Plugin" },
      ["<leader>s"] = { name = "+Search" },
      ["<leader>t"] = { name = "+Term" },
    },
  },
  config = function(_, opts)
    require("which-key").setup {
      plugins = opts.plugins,
      key_labels = opts.key_labels,
    }

    require("which-key").register(opts.register)
  end,
}
