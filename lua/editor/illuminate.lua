return {
  "RRethy/vim-illuminate",
  event = "BufReadPost",
  -- stylua: ignore
  keys = {
    { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next reference" },
    { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Previous reference" },
  },
}
