local M = {}

function M.keymap(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, {
    silent = true,
    buffer = opts.buffer,
    desc = opts.desc,
  })
end

return M
