local M = {}

function M.setup_diagnostic_signs(signs, diagnostics)
  for _, sign in ipairs(signs) do
    if not sign.texthl then sign.texthl = sign.name end
    vim.fn.sign_define(sign.name, sign)
  end

  vim.diagnostic.config(diagnostics)
end

local function keymap(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, {
    silent = true,
    buffer = opts.buffer,
    desc = opts.desc,
  })
end

local function setup_lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  return capabilities
end

local function setup_lsp_on_attach()
  local function on_attach(client, bufnr)
    local ft = vim.bo[bufnr].filetype
    local has_null_ls_formatting = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

    local server_capabilities = client.server_capabilities

    if server_capabilities.definitionProvider then
      keymap("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
    end

    if server_capabilities.declarationProvider then
      keymap("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
    end

    if server_capabilities.implementationProvider then
      keymap("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
    end

    if server_capabilities.referencesProvider then
      keymap("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to references" })
    end

    if server_capabilities.typeDefinitionProvider then
      keymap("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go to type definitions" })
    end

    if server_capabilities.codeActionProvider then
      keymap({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action (LSP)" })
    end

    if server_capabilities.documentFormattingProvider and not has_null_ls_formatting then
      keymap({ "n", "v" }, "<leader>lf", vim.lsp.buf.format, { buffer = bufnr, desc = "Format code (LSP)" })
    end

    if server_capabilities.codeLensProvider then
      keymap("n", "<leader>lL", vim.lsp.codelens.run, { buffer = bufnr, desc = "CodeLens action" })
    end

    if server_capabilities.renameProvider then
      keymap("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename current symbol" })
    end

    if server_capabilities.signatureHelpProvider then
      keymap("n", "<leader>ls", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
    end

    keymap("n", "<leader>ll", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line diagnostics" })
    keymap("n", "<leader>lq", vim.diagnostic.setloclist, { buffer = bufnr, desc = "List diagnostic" })
    keymap("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostic" })
    keymap("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostic" })
  end

  return on_attach
end

function M.setup_lspconfig(servers)
  local default_handlers = {
    on_attach = setup_lsp_on_attach(),
    capabilities = setup_lsp_capabilities(),
  }

  for _, server in ipairs(servers) do
    local has_extra_handlers, extra_handlers = pcall(require, "coding.lspconfig." .. server)

    if has_extra_handlers then
      require("lspconfig")[server].setup(vim.tbl_deep_extend("force", default_handlers, extra_handlers))
    else
      require("lspconfig")[server].setup(default_handlers)
    end
  end
end

function M.setup_null_ls_on_attach()
  local function on_attach(_, bufnr)
    keymap({ "n", "v" }, "<leader>lf", function()
      vim.lsp.buf.format { bufnr = bufnr, filter = function(client) return client.name == "null-ls" end }
    end, { buffer = bufnr, desc = "Format code (null-ls)" })

    keymap({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action (null-ls)" })
  end

  return on_attach
end

return M
