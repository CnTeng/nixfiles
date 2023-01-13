-- TODO:change keymap
return {
  {
    "goolord/alpha-nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VimEnter",
    keys = {
      { "<leader>a", "<cmd>Alpha<cr>", desc = "Alpha" },
    },
    opts = function()
      local dashboard = require "alpha.themes.dashboard"
      dashboard.section.header.val = {
        "                                                          ",
        "  ██████  ██   ██       ███    ██ ██    ██ ██ ███    ███  ",
        "  ██   ██  ██ ██        ████   ██ ██    ██ ██ ████  ████  ",
        "  ██████    ███   █████ ██ ██  ██ ██    ██ ██ ██ ████ ██  ",
        "  ██   ██  ██ ██        ██  ██ ██  ██  ██  ██ ██  ██  ██  ",
        "  ██   ██ ██   ██       ██   ████   ████   ██ ██      ██  ",
        "                                                          ",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  > Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", "  > New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  > Recent file", ":Telescope oldfiles <CR>"),
        dashboard.button("t", "  > Find text", ":Telescope live_grep <CR>"),
        dashboard.button("q", "  > Quit Neovim", ":qa<CR>"),
      }

      dashboard.section.footer.val = "Just for fun!"
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"
      return dashboard
    end,
    config = function(_, dashboard)
      require("alpha").setup(dashboard.opts)
    end,
  },
}
