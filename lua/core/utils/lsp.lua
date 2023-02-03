local M = {}

function M.keymap(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, {
    silent = true,
    buffer = opts.buffer,
    desc = opts.desc,
  })
end

function M.setup_handlers(default_handlers)
  local lspconfig = require "lspconfig"

  -- require("mason-lspconfig").setup_handlers {
  --   function(server_name)
  --     local has_extra_handlers, extra_handlers = pcall(require, "coding.lsp.servers." .. server_name)
  --     if has_extra_handlers then
  --       lspconfig[server_name].setup(vim.tbl_deep_extend("force", default_handlers, extra_handlers))
  --     else
  --       lspconfig[server_name].setup(default_handlers)
  --     end
  --   end,
  -- }
end

return M
