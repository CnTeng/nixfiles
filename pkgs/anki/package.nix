{ prev }:
prev.anki.overrideAttrs (old: {
  patches = old.patches ++ [ ./fix-compilation-under-rust-1.89.patch ];
})
