return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    opts = function()
      local null_ls = require "null-ls"
      return {
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.nixpkgs_fmt,
          -- null_ls.builtins.diagnostics.cspell,
          -- null_ls.builtins.code_actions.cspell,
          null_ls.builtins.formatting.prettier,
        },
      }
    end,
  },
}
