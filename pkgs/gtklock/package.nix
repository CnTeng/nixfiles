{ prev }:
prev.gtklock.overrideAttrs (old: {
  patches = [ ./ensure-single-instance.patch ];
})
