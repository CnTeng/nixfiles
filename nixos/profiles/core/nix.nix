{ inputs, ... }:
{
  nix.channel.enable = false;

  nix.registry.nixpkgs.flake = inputs.nixpkgs;

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

    nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];
    substituters = [
      "https://cache.garnix.io"
      "https://cosmic.cachix.org"
    ];
    trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    use-cgroups = true;
    use-xdg-base-directories = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
