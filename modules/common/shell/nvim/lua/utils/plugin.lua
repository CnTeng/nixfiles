local M = {}

M.plugins = {}

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

--- Require plugin and check if it exists
---@param plugin_name string
---@return any
function M.pcall(plugin_name)
	local status_ok, plugin = pcall(require, plugin_name)
	if not status_ok then
		local info = debug.getinfo(2, "Sl")
		local file = info.short_src
		local line = info.currentline
		local _hint = "require_plugin: Failed to load '%s'\n(%s: %d)"
		local hint = _hint:format(plugin_name, file, line)
		vim.notify(hint, vim.log.levels.WARN)
		return nil
	else
		return plugin
	end
end

--- Add plugin
---@param plugin table
function M.add(plugin) table.insert(M.plugins, plugin) end

--- Load plugin
function M.load()
	local lazy = M.pcall "lazy"
	if not lazy then return end
	local opts = {
		defaults = { lazy = false },
		install = {
			missing = true,
			colorscheme = { "catppuccin", "habamax" },
		},
	}
	lazy.setup (M.plugins, opts)
end

return M
