return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
  keys = {
    { "<leader>/", function() require("Comment.api").toggle.linewise.current() end, desc = "Comment line" },
    {
      "<leader>/",
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      mode = "v",
      desc = "Comment line",
    },
  },
  opts = function()
    return {
      ignore = "^$", -- ignores empty lines
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }
  end,
}
