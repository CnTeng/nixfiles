{ prev }:
prev.outline.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [ ./fix-mobile-image-resize.patch ];
})
