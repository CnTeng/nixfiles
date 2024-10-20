{ prev }:
prev.sioyek.overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [ prev.qt6.qtwayland ];
})
