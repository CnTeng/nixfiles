local plugin = require "utils.plugin"

local todo = plugin.pcall "todo-comments"
if not todo then return end

-- TODO:add support for telescope
todo.setup()
