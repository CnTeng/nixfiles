-- TODO:change dashboard section
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
      dashboard.opts.layout[1].val = 6

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
        dashboard.button("LDR f f", "  > Find files", ":Telescope find_files <CR>"),
        dashboard.button("LDR f l", "  > New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("LDR f r", "  > Recent file", ":Telescope oldfiles <CR>"),
        dashboard.button("LDR s w", "  > Search text", ":Telescope live_grep <CR>"),
        dashboard.button("LDR q", "  > Quit Neovim", ":qa<CR>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "keyword"
        button.opts.hl_shortcut = "DashboardShortCut"
      end
      dashboard.section.header.opts.hl = "DashboardHeader"
      dashboard.section.footer.opts.hl = "DashboardFooter"

      return dashboard
    end,
    config = function(_, dashboard) require("alpha").setup(dashboard.opts) end,
  },
}
