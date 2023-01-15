return {
  {
    "rcarriga/nvim-notify",
    opts = {
      fps = 60,
      render = "minimal",
      stages = "slide",
      timeout = 3000,
    },
    config = function(_, opts)
      local notify = require "notify"

      notify.setup(opts)
      vim.notify = notify
    end,
  },
}
