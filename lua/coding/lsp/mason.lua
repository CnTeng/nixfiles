return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Linter
        "flake8",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      for _, tool in ipairs(opts.ensure_installed) do
        local package = mr.get_package(tool)
        if not package:is_installed() then package:install() end
      end
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "jsonls",
        "sumneko_lua",
        "clangd",
        "gopls",
        "pyright",
        "nil_ls",
      },
      automatic_installation = true,
    },
  },
}
