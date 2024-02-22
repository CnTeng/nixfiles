prev:
prev.caddy.override {
  buildGoModule =
    args:
    prev.buildGoModule (
      args
      // {
        vendorHash = "sha256-dnKAwOrQkICkUVsyWJO+o2N4HcImLaL+fPyq8hUd5/8=";
        patches = [ ./caddy-with-plugins.patch ];
      }
    );
}
