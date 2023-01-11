local plugin = require "utils.plugin"

local gitsigns = plugin.pcall "gitsigns"
if not gitsigns then return end

gitsigns.setup {
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "▎" },
		topdelete = { text = "契" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},
}
