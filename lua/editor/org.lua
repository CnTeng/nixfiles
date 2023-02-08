return {
  "nvim-orgmode/orgmode",
  ft = "org",
  dependencies = {
    { "akinsho/org-bullets.nvim", config = true },
    -- { "lukas-reineke/headlines.nvim", config = true },
  },
  init = function()
    vim.opt.conceallevel = 2
    vim.opt.concealcursor = "nc"
    vim.opt.shellslash = true
  end,
  config = function()
    require("orgmode").setup_ts_grammar()
    require("orgmode").setup()
  end,
}
