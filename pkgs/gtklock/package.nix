{ prev }:
prev.gtklock.overrideAttrs (old: {
  patches = [ ./ensure_single_instance.patch ];
})
