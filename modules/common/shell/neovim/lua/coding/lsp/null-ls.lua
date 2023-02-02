return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    -- event = "BufReadPre",
    dependencies = "williamboman/mason.nvim",
    opts = function()
      local nls = require "null-ls"
      return {
        sources = {
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- "stylua",
        -- "prettier",
        -- "cpplint",
        -- "golines",
        -- "black",
        -- "shfmt",
        "stylua",
        "prettier",
        "cpplint",
        "clang-format",
        "golines",
        "black",
        "shfmt",
      },
    },
  },
}
