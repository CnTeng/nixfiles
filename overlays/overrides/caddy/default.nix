prev:
prev.caddy.override {
  buildGoModule = args:
    prev.buildGoModule (args // {
      vendorHash = "sha256-LB66Qug8cTp0+7Q5rU+yCkQyR/V4+0Mmw2ZjEDo5qy0=";
      patches = [ ./caddy-with-plugins.patch ];
    });
}
