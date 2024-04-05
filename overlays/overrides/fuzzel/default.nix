{ prev, source, ... }:
prev.fuzzel.overrideAttrs (oldAttrs: {
  inherit (source) src;
})
