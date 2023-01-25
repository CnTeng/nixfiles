local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    -- event = "BufReadPre",
    keys = {
      { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP info" },
    },
    opts = {
      diagnostics = {
        underline = true,
        signs = { active = signs },
        virtual_text = { spacing = 2, prefix = "●" },
        update_in_insert = false,
        severity_sort = true,
      },
    },
    config = function(_, opts)
      for _, sign in ipairs(signs) do
        if not sign.texthl then sign.texthl = sign.name end
        vim.fn.sign_define(sign.name, sign)
      end

      vim.diagnostic.config(opts.diagnostics)
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local on_attach = function(_, bufnr)
        local keymap = require("core.utils.lsp").keymap

        keymap("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
        keymap("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
        keymap("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
        keymap("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
        keymap("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to references" })
        keymap("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go to type definitions" })
        keymap({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
        keymap({ "n", "v" }, "<leader>lf", vim.lsp.buf.format, { buffer = bufnr, desc = "Format code" })
        keymap("n", "<leader>ll", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line diagnostics" })
        keymap("n", "<leader>lL", vim.lsp.codelens.run, { buffer = bufnr, desc = "CodeLens action" })
        keymap("n", "<leader>lq", vim.diagnostic.setloclist, { buffer = bufnr, desc = "List diagnostic" })
        keymap("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename current symbol" })
        keymap("n", "<leader>ls", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
        keymap("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostic" })
        keymap("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostic" })
      end

      local default_handlers = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      require("core.utils.lsp").setup_handlers(default_handlers)
    end,
  },
}
