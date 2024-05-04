{ prev, ... }:
prev.kitty.overrideAttrs (oldAttrs: {
  patches = oldAttrs.patches ++ [ ./fix-fcitx5.patch ];
})
