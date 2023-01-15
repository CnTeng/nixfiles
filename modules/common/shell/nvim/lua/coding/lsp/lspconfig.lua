local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

return {
  {
    "neovim/nvim-lspconfig",
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

      ---@diagnostic disable-next-line: unused-local
      local on_attach = function(client, bufnr)
        local keymap = require("core.utils.lsp").keymap

        keymap("n", "K", function() vim.lsp.buf.hover() end, { buffer = bufnr, desc = "Hover" })
        keymap("n", "gd", function() vim.lsp.buf.definition() end, { buffer = bufnr, desc = "Goto definition" })
        keymap("n", "gD", function() vim.lsp.buf.declaration() end, { buffer = bufnr, desc = "Goto declaration" })
        keymap("n", "gI", function() vim.lsp.buf.implementation() end, { buffer = bufnr, desc = "Goto implementation" })
        keymap("n", "gr", function() vim.lsp.buf.references() end, { buffer = bufnr, desc = "Goto references" })
        keymap("n", "gt", function() vim.lsp.buf.type_definitions() end,
          { buffer = bufnr, desc = "Goto type definitions" })
        keymap("n", "<leader>li", "<cmd>LspInfo<cr>", { buffer = bufnr, desc = "LSP info" })
        keymap("n", "<leader>lI", "<cmd>Mason<cr>", { buffer = bufnr, desc = "Installer info" })
        keymap("n", "<leader>lf", function() vim.lsp.buf.format() end, { buffer = bufnr, desc = "Format code" })
        keymap("n", "<leader>la", function() vim.lsp.buf.code_action() end, { buffer = bufnr, desc = "Code action" })
        keymap("n", "<leader>lr", function() vim.lsp.buf.rename() end, { buffer = bufnr, desc = "Rename current symbol" })
        keymap("n", "<leader>ls", function() vim.lsp.buf.signature_help() end,
          { buffer = bufnr, desc = "Signature help" })
        keymap("n", "<leader>lL", function() vim.lsp.codelens.run() end, { buffer = bufnr, desc = "CodeLens action" })
        keymap("n", "<leader>ll", function() vim.diagnostic.open_float() end,
          { buffer = bufnr, desc = "Line diagnostics" })
        keymap("n", "<leader>lq", function() vim.diagnostic.setloclist() end,
          { buffer = bufnr, desc = "List diagnostic" })
        keymap("n", "]d", function() vim.diagnostic.goto_next() end, { buffer = bufnr, desc = "Next diagnostic" })
        keymap("n", "[d", function() vim.diagnostic.goto_prev() end, { buffer = bufnr, desc = "Previous diagnostic" })

        keymap("v", "<leader>la", function() vim.lsp.buf.code_action() end,
          { buffer = bufnr, desc = "Range code action" })
        keymap("v", "<leader>lf", function() vim.lsp.buf.format() end, { buffer = bufnr, desc = "Range format code" })
      end

      local default_handlers = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      require("core.utils.lsp").setup_handlers(default_handlers)
    end,
  },
}
