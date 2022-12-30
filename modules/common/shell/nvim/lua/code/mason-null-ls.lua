local null_ls = require "null-ls"

require("mason-null-ls").setup {
	ensure_installed = { "stylua" },
}

require("mason-null-ls").setup_handlers {
	function(source_name)
		-- all sources with no handler get passed here
	end,
	stylua = function() null_ls.register(null_ls.builtins.formatting.stylua) end,
}

-- will setup any installed and configured sources above
null_ls.setup()
