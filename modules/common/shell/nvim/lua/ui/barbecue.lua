local plugin = require "utils.plugin"

local barbecue = plugin.pcall "barbecue"
if not barbecue then return end

barbecue.setup {
	theme = "catppuccin",
}
