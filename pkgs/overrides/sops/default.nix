prev: _:
prev.sops.override {
  buildGoModule =
    args:
    prev.buildGoModule (
      args
      // {
        vendorHash = "sha256-VKhdsth8HBk1uv8f6TiqE9G8bZhbkswuYodw9+NAXBc=";
        patches = [ ./filename-override.diff ];
      }
    );
}
