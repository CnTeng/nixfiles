return {
  {
    "williamboman/mason.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>lI", "<cmd>Mason<cr>", desc = "Installer info" },
    },
    config = true,
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
