return {
  "s1n7ax/nvim-window-picker",
  keys = {
    {
      "gw",
      function()
        local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(picked_window_id)
      end,
      desc = "Pick a window",
    },
  },
  opts = {
    include_current_win = true,
    use_winbar = "smart",
    filter_rules = { bo = { buftype = {} } },
    fg_color = "#ededed",
    current_win_hl_color = "#e35e4f",
    other_win_hl_color = "#44cc41",
  },
}
