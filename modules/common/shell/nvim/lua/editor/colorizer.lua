local plugin = require "utils.plugin"

local colorizer = plugin.pcall "colorizer"
if not colorizer then return end

colorizer.setup {
	user_default_options = {
		names = false,
	},
}
