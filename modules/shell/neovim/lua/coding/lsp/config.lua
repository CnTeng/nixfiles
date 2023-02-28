return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/neodev.nvim",
      opts = { experimental = { pathStrict = true } },
    },
    { "j-hui/fidget.nvim", opts = { window = { blend = 0 } } },
    { "hrsh7th/cmp-nvim-lsp" },
  },
  keys = {
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP info" },
  },
  opts = function()
    local signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn", text = "" },
      { name = "DiagnosticSignHint", text = "" },
      { name = "DiagnosticSignInfo", text = "" },
    }
    return {
      signs = signs,
      diagnostics = {
        underline = true,
        signs = { active = signs },
        virtual_text = { spacing = 2, prefix = "●" },
        update_in_insert = false,
        severity_sort = true,
      },
      servers = {
        "lua_ls", -- Lua
        "bashls", -- Shell
        "clangd", -- C++ & C
        "nil_ls", -- Nix
        "pylsp", -- Python
        "marksman", -- Markdown
      },
    }
  end,
  config = function(_, opts)
    require("core.utils.lsp").setup_diagnostic_signs(opts.signs, opts.diagnostics)

    require("core.utils.lsp").setup_lspconfig(opts.servers)
  end,
}
