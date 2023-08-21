prev:
prev.gtklock.overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [prev.wrapGAppsHook];
  buildInputs = old.buildInputs ++ [prev.librsvg];
})
