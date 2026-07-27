{
  nix.channel.enable = false;

  nix.settings = {
    auto-allocate-uids = true;
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = [
      "auto-allocate-uids"
      "ca-derivations"
      "cgroups"
      "flakes"
      "nix-command"
    ];

    substituters = [ "https://cache.snakepi.xyz" ];
    trusted-public-keys = [ "cache.snakepi.xyz:WdGroyejMlx4d8XIbFK/SKxu8riTPHn428fJul/Cw60=" ];
    trusted-users = [ "@wheel" ];
    use-cgroups = true;
    use-xdg-base-directories = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
