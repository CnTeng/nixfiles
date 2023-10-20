prev:
prev.caddy.override {
  buildGoModule = args:
    prev.buildGoModule (args
      // {
        vendorHash = "sha256-AVaKjaWtbcBKgZIlTAi5wiTd2XzqdIYWtXxFGahcQEE=";
        patches = [./caddy-with-plugins.patch];
      });
}
