return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      key_labels = { ["<leader>"] = "SPC" },
    },
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      --[[ local which_key = require "which-key" ]]
      --[[]]
      --[[ local opts = { ]]
      --[[   mode = "n", -- NORMAL mode ]]
      --[[   prefix = "<leader>", ]]
      --[[   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings ]]
      --[[   silent = true, -- use `silent` when creating keymaps ]]
      --[[   noremap = true, -- use `noremap` when creating keymaps ]]
      --[[   nowait = true, -- use `nowait` when creating keymaps ]]
      --[[ } ]]
      --[[]]
      --[[ local vopts = { ]]
      --[[   mode = "v", -- NORMAL mode ]]
      --[[   prefix = "<leader>", ]]
      --[[   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings ]]
      --[[   silent = true, -- use `silent` when creating keymaps ]]
      --[[   noremap = true, -- use `noremap` when creating keymaps ]]
      --[[   nowait = true, -- use `nowait` when creating keymaps ]]
      --[[ } ]]
      --[[]]
      --[[   -- Packer ]]
      --[[   p = { ]]
      --[[     name = "Packer", ]]
      --[[     c = { "<cmd>PackerCompile<cr>", "Compile" }, ]]
      --[[     i = { "<cmd>PackerInstall<cr>", "Install" }, ]]
      --[[     s = { "<cmd>PackerSync<cr>", "Sync" }, ]]
      --[[     S = { "<cmd>PackerStatus<cr>", "Status" }, ]]
      --[[     u = { "<cmd>PackerUpdate<cr>", "Update" }, ]]
      --[[   }, ]]
      --[[   l = { ]]
      --[[     name = "LSP", ]]
      --[[     i = { "<cmd>LspInfo<cr>", "LSP info" }, ]]
      --[[     I = { "<cmd>Mason<cr>", "Installer info" }, ]]
      --[[     f = { ]]
      --[[       function() vim.lsp.buf.format() end, ]]
      --[[       "Format code", ]]
      --[[     }, ]]
      --[[     a = { ]]
      --[[       function() vim.lsp.buf.code_action() end, ]]
      --[[       "Code action", ]]
      --[[     }, ]]
      --[[     r = { ]]
      --[[       function() vim.lsp.buf.rename() end, ]]
      --[[       "Rename current symbol", ]]
      --[[     }, ]]
      --[[     s = { ]]
      --[[       function() vim.lsp.buf.signature_help() end, ]]
      --[[       "Signature help", ]]
      --[[     }, ]]
      --[[     L = { ]]
      --[[       function() vim.lsp.codelens.run() end, ]]
      --[[       "CodeLens action", ]]
      --[[     }, ]]
      --[[     j = { ]]
      --[[       function() vim.lsp.diagnostic.goto_next() end, ]]
      --[[       "Next diagnostic", ]]
      --[[     }, ]]
      --[[     k = { ]]
      --[[       function() vim.lsp.diagnostic.goto_prev() end, ]]
      --[[       "Prev diagnostic", ]]
      --[[     }, ]]
      --[[     l = { ]]
      --[[       function() vim.lsp.diagnostic.set_loclist() end, ]]
      --[[       "List diagnostic", ]]
      --[[     }, ]]
      --[[     d = { ]]
      --[[       function() require("telescope.builtin").diagnostics() end, ]]
      --[[       "Search diagnostics", ]]
      --[[     }, ]]
      --[[     R = { ]]
      --[[       function() require("telescope.builtin").lsp_references() end, ]]
      --[[       "Search references", ]]
      --[[     }, ]]
      --[[   }, ]]
      --[[]]
      --[[   t = { ]]
      --[[     name = "Terminal", ]]
      --[[     f = { "<cmd>ToggleTerm direction=float<cr>", "Float" }, ]]
      --[[     h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" }, ]]
      --[[     v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" }, ]]
      --[[   }, ]]
      --[[ } ]]
      --[[]]
      --[[ local vmappings = { ]]
      --[[   l = { ]]
      --[[     name = "LSP", ]]
      --[[     a = { ]]
      --[[       function() vim.lsp.buf.range_code_action() end, ]]
      --[[       "Range code action", ]]
      --[[     }, ]]
      --[[     f = { ]]
      --[[       function() ]]
      --[[         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false) ]]
      --[[         vim.lsp.buf.range_formatting() ]]
      --[[       end, ]]
      --[[       "Range format code", ]]
      --[[     }, ]]
      --[[   }, ]]
      --[[ } ]]

      local wk = require "which-key"
      wk.setup(opts)
      wk.register {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>g"] = { name = "+Git" },
        ["<leader>f"] = { name = "+Search" },
      }
    end,
  },
}
