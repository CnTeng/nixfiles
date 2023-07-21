prev:
prev.caddy.override {
  buildGoModule = args:
    prev.buildGoModule (args
      // {
        vendorHash = "sha256-Yp83IEmL/6tUn5UrzpApu0rV9YmAOqh7ObdAwwT2Fe0=";
        patches = [./caddy-with-plugins.patch];
      });
}
