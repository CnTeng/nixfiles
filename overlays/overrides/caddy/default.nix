prev:
prev.caddy.override {
  buildGoModule = args:
    prev.buildGoModule (args
      // {
        vendorHash = "sha256-q2Ytw/qo+sGuTwcDnFsBcUpJvDdPOwZPyvNFUX0RFK8=";
        patches = [./caddy-with-plugins.patch];
      });
}
