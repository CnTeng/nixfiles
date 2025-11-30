{ prev }:
prev.aerc.overrideAttrs (old: {
  patches = [ ./exit_like_vim.diff ];
})
