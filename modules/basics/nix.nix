{ config, lib, ... }:
with lib;
let cfg = config.basics'.nix;
in {
  options.basics'.nix = {
    enable = mkEnableOption "nix config" // { default = true; };
  };

  config = mkIf cfg.enable {
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      settings = {
        allowed-users = [ "@wheel" ];
        trusted-users = [ "root" "@wheel" ];
        auto-optimise-store = true;
        system-features = [ "big-parallel" ];
        keep-outputs = true;
        keep-derivations = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    system = {
      autoUpgrade = {
        enable = false;
        channel = "https://nixos.org/channels/nixos-unstable";
      };
      stateVersion = "23.05";
    };
  };
}
