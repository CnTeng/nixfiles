{ user, ... }:

{
  imports = [
    ./naive.nix
    ./v2ray.nix
    # ./nix.nix
    ./git.nix
    ./cargo.nix
  ];

  # Proxy for system
  networking.proxy.default = "http://127.0.0.1:10809";
}
