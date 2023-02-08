return {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPre",
  opts = function()
    local null_ls = require "null-ls"
    return {
      sources = {
        null_ls.builtins.formatting.stylua.with {
          filetypes = { "lua", "luau", "org" },
        }, -- Lua
        null_ls.builtins.formatting.shfmt, -- Shell
        null_ls.builtins.formatting.black, -- Python
        null_ls.builtins.formatting.prettier, -- Markdown
        null_ls.builtins.diagnostics.todo_comments,
      },
      on_attach = require("core.utils.lsp").setup_null_ls_on_attach(),
    }
  end,
}
