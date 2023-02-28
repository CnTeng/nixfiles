{ config, lib, user, ... }:

with lib;

let cfg = config.custom.basics.nix;
in {
  options.custom.basics.nix = {
    enable = mkEnableOption "nix config" // { default = true; };
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = true;
        system-features = [ "big-parallel" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      settings = { experimental-features = [ "nix-command" "flakes" ]; };
    };

    nixpkgs.config.allowUnfree = true;

    system = {
      autoUpgrade = {
        enable = false;
        channel = "https://nixos.org/channels/nixos-unstable";
      };
      stateVersion = "23.05";
    };

    home-manager.users.${user} = {
      home = {
        username = "${user}";
        homeDirectory = "/home/${user}";
        stateVersion = "23.05";
      };

      programs = { home-manager.enable = true; };
    };
  };
}
