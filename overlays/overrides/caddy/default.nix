prev:
prev.caddy.override {
  buildGoModule =
    args:
    prev.buildGoModule (
      args
      // {
        vendorHash = "sha256-rRx2nzYXNA3tl/roFvDLsEhpDT93yFq+hG1BlIzwIi4=";
        patches = [ ./caddy-with-plugins.patch ];
      }
    );
}
