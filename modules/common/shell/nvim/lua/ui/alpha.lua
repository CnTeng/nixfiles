local plugin = require "utils.plugin"

local alpha = plugin.pcall "alpha"
if not alpha then return end

local dashboard = plugin.pcall "alpha.themes.dashboard"
if not dashboard then return end

dashboard.section.header.val = {
	"                                                     ",
	"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
	"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
	"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
	"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
	"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
	"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
	"                                                     ",
}

dashboard.section.buttons.val = {
	dashboard.button("f", "  > Find file", ":Telescope find_files <CR>"),
	dashboard.button("n", "  > New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("r", "  > Recent file", ":Telescope oldfiles <CR>"),
	dashboard.button("t", "  > Find text", ":Telescope live_grep <CR>"),
	dashboard.button("q", "  > Quit Neovim", ":qa<CR>"),
}

dashboard.section.footer.val = "Just for fun!"
dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)
