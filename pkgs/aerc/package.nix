{ prev }:
prev.aerc.overrideAttrs (old: {
  patches = [ ./exit-like-vim.patch ];
})
