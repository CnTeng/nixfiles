return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "famiu/bufdelete.nvim",
    },
    event = "BufEnter",
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = function()
      return {
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "Bdelete! %d",
          right_mouse_command = "Bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = "▎", -- this should be omitted if indicator style is not 'icon'
            style = "icon", -- 'icon' | 'underline' | 'none',
          },
          buffer_close_icon = "",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 20,
          diagnostics = false,
          diagnostics_update_in_insert = false,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_buffer_default_icon = true,
          show_close_icon = true,
          show_tab_indicators = true,
          show_duplicate_prefix = true,
          persist_buffer_sort = true,
          separator_style = "thin",
          enforce_regular_tabs = true,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
        },
        highlights = require("catppuccin.groups.integrations.bufferline").get {
          styles = { "bold" },
        },
      }
    end,
  },
}
