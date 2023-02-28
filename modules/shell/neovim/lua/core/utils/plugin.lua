local M = {}

--- Bootstrap plugin manager Lazy
local function plugin_manager_bootstrap()
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

--- Set Lazy keymaps
local function plugin_manager_keymap()
  local keymap = vim.keymap.set

  keymap("n", "<leader>ph", "<cmd>Lazy<cr>", { desc = "Lazy home" })
  keymap("n", "<leader>pc", "<cmd>Lazy check<cr>", { desc = "Lazy check" })
  keymap("n", "<leader>pl", "<cmd>Lazy log<cr>", { desc = "Lazy log" })
  keymap("n", "<leader>pp", "<cmd>Lazy profile<cr>", { desc = "Lazy profile" })
  keymap("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Lazy sync" })
  keymap("n", "<leader>pu", "<cmd>Lazy update<cr>", { desc = "Lazy update" })
end

--- Load plugins
---@param spec table
function M.load(spec)
  plugin_manager_bootstrap()
  plugin_manager_keymap()

  local opts = {
    install = {
      missing = true,
      colorscheme = { "catppuccin", "habamax" },
    },
    performance = {
      rtp = { reset = false },
    },
  }
  require("lazy").setup(spec, opts)
end

return M
