local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("unlist_quickfist", { clear = true }),
  pattern = { "qf", "help", "man", "notify", "lspinfo" },
  callback = function() vim.opt_local.buflisted = false end,
})

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

local alpha_settings = augroup("alpha_settings", { clear = true })
autocmd("User", {
  desc = "Disable status and tablines for alpha",
  group = alpha_settings,
  pattern = "AlphaReady",
  callback = function()
    local prev_showtabline = vim.opt.showtabline
    vim.opt.showtabline = 0
    vim.opt_local.winbar = nil
    autocmd("BufUnload", {
      pattern = "<buffer>",
      callback = function() vim.opt.showtabline = prev_showtabline end,
    })
  end,
})

autocmd("User", {
  desc = "Display plugins loading time in alpha",
  group = alpha_settings,
  pattern = "LazyVimStarted",
  callback = function()
    local dashboard = require "alpha.themes.dashboard"
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
    pcall(vim.cmd.AlphaRedraw)
  end,
})
