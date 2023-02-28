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
    triggers_blacklist = {
      i = { "j", "k" },
      v = { "j", "k" },
      n = { "L" },
    },
    register = {
      mode = { "n", "v" },
      ["]"] = { name = "+Next" },
      ["["] = { name = "+Prev" },
      ["g"] = { name = "+Goto" },
      ["gz"] = { name = "+Surround" },
      ["<leader>b"] = { name = "+Buffer" },
      ["<leader>d"] = { name = "+Debugger" },
      ["<leader>f"] = { name = "+File" },
      ["<leader>g"] = { name = "+Git" },
      ["<leader>l"] = { name = "+LSP" },
      ["<leader>o"] = { name = "+Org" },
      ["<leader>p"] = { name = "+Plugin" },
      ["<leader>s"] = { name = "+Search" },
      ["<leader>t"] = { name = "+Term" },
    },
  },
  config = function(_, opts)
    require("which-key").setup {
      plugins = opts.plugins,
      key_labels = opts.key_labels,
      triggers_blacklist = opts.triggers_blacklist,
    }

    require("which-key").register(opts.register)
  end,
}
