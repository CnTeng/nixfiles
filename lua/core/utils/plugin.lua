local M = {}

--- Bootstrap the plugin manager lazy
function M.init()
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
end

--- Load plugins
---@param plugins table
function M.load(plugins)
  M.init()

  local opts = {
    defaults = { lazy = false },
    install = {
      missing = true,
      colorscheme = { "catppuccin", "habamax" },
    },
  }
  require("lazy").setup(plugins, opts)
end

return M
