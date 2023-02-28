return {
  "glacambre/firenvim",
  build = function()
    require("lazy").load { plugins = "firenvim", wait = true }
    vim.fn["firenvim#install"](0)
  end,
  cond = not not vim.g.started_by_firenvim,
  config = function()
    vim.opt.laststatus = 0
    vim.opt.guifont = { "FiraCode Nerd Font", ":h13" }
  end,
}
