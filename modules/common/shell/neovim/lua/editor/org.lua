return {
  "nvim-orgmode/orgmode",
  ft = "org",
  init = function()
    vim.opt.conceallevel = 2
    vim.opt.concealcursor = "nc"
    vim.opt.shellslash = true
  end,
  config = true,
}
