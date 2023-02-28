return {
  "ggandor/leap.nvim",
  dependencies = {
    { "ggandor/flit.nvim", config = true },
    "tpope/vim-repeat",
  },
  config = function()
    require("leap").add_default_mappings(true)
    vim.keymap.del({ "x", "o" }, "x")
    vim.keymap.del({ "x", "o" }, "X")
  end,
}
