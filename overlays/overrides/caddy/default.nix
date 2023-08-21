prev:
prev.caddy.override {
  buildGoModule = args:
    prev.buildGoModule (args
      // {
        vendorHash = "sha256-j1h/jalaau5Nh4IbL5AlWH9YgqkFusfASGtau5qJD8c=";
        patches = [./caddy-with-plugins.patch];
      });
}
