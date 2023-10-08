prev:
prev.cinnamon.overrideScope' (cfinal: cprev: {
  nemo = cprev.nemo.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [./nemo-avoid-segfault.patch];
  });
})
