local plugin = require "utils.plugin"

local notify = plugin.pcall "notify"
if not notify then return end

notify.setup {
	fps = 60,
	render = "minimal",
	stages = "slide",
	timeout = 3000,
}
vim.notify = notify
