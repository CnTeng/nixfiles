prev:
prev.caddy.override {
  buildGoModule =
    args:
    prev.buildGoModule (
      args
      // {
        vendorHash = "sha256-xu0BLjLS3u0lkZjM+IDZAhcC8KccQrf67BW4cU9rWQM=";
        patches = [ ./caddy-with-plugins.patch ];
      }
    );
}
