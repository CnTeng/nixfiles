{ config, lib, pkgs, inputs, user, ... }:
with lib;

let
  cfg = config.custom.basics.security;
  inherit (config.home-manager.users.${user}.home) homeDirectory;
in {
  imports = [ inputs.agenix.nixosModules.default ];

  options.custom.basics.security = {
    enable = mkEnableOption "security config" // { default = true; };
  };

  config = mkIf cfg.enable {
    security = {
      tpm2.enable = true;
      rtkit.enable = true;
      sudo.wheelNeedsPassword = false;
    };

    environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ]
      ++ (with pkgs; [ rage age-plugin-yubikey ]);

    age.identityPaths = [
      # TODO: add yubikey-yufei
      # "../../../secrets/identities/yubikey-yufei.txt"

      "${homeDirectory}/.ssh/id_ed25519"
    ];
  };
}
