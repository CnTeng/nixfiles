local M = {}

function M.setup_dap_signs(signs)
  for _, sign in ipairs(signs) do
    if not sign.texthl then sign.texthl = sign.name end
    vim.fn.sign_define(sign.name, sign)
  end
end

return M
