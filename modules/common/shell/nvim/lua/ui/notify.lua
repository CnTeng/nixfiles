local status_ok, notify = pcall(require, "notify")
if not status_ok then
	vim.notify("notify not found!", "error")
	return
end

notify.setup {
	background_colour = "Normal",
	fps = 60,
	icons = {
		DEBUG = "",
		ERROR = "",
		INFO = "",
		TRACE = "✎",
		WARN = "",
	},
	level = 2,
	minimum_width = 50,
	render = "minimal",
	stages = "fade_in_slide_out",
	timeout = 3000,
}
vim.notify = notify
