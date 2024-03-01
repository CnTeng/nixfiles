prev:
prev.sway-unwrapped.overrideAttrs (
  oldAttrs: {
    patches = oldAttrs.patches ++ [
      (prev.fetchpatch {
        name = "0001-text_input-Implement-input-method-popups.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-text_input-Implement-input-method-popups.patch?h=sway-im";
        sha256 = "sha256-A+rBaWMWs616WllVoo21AJaf9lxg/oCG0b9tHLfuJII=";
      })
      (prev.fetchpatch {
        name = "0002-chore-fractal-scale-handle.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0002-chore-fractal-scale-handle.patch?h=sway-im";
        sha256 = "sha256-YOFm0A4uuRSuiwnvF9xbp8Wl7oGicFGnq61vLegqJ0E=";
      })
      (prev.fetchpatch {
        name = "0003-chore-left_pt-on-method-popup.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0003-chore-left_pt-on-method-popup.patch?h=sway-im";
        sha256 = "sha256-PzhQBRpyB1WhErn05UBtBfaDW5bxnQLRKWu8jy7dEiM=";
      })
    ];
  }
)
