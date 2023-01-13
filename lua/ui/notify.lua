return {
  {
    "rcarriga/nvim-notify",
    opts = {
      fps = 60,
      render = "minimal",
      stages = "slide",
      timeout = 3000,
    },
    config = function()
      vim.notify = require "notify"
    end,
  },
}
