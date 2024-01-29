prev:
prev.sway-unwrapped.overrideAttrs (
  oldAttrs: {
    patches = oldAttrs.patches ++ [
      (prev.fetchpatch {
        name = "0001-text_input-Implement-input-method-popups.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-text_input-Implement-input-method-popups.patch?h=sway-im";
        sha256 = "sha256-xrBnQhtA6LgyW0e0wKwymlMvx/JfrjBidq1a3GFKzZo=";
      })
      (prev.fetchpatch {
        name = "0002-backport-sway-im-to-v1.8.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/0002-backport-sway-im-to-v1.8.patch?h=sway-im";
        sha256 = "sha256-IpyipHgoXl7vVmBpBULiS6WtieMfkeARB+930Fl+51c=";
      })
    ];
  }
)
