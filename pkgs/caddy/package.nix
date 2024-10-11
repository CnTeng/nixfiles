{ prev }:

prev.override (prev: {
  buildGoModule =
    args:
    prev.buildGoModule (
      args
      // {
        vendorHash = "sha256-/Vj8Yn34c81W1KZoCogfG3Z3fzmJnjvubxq3nIqHxm4=";
        patches = [ ./caddy-with-plugins.diff ];
      }
    );
})
