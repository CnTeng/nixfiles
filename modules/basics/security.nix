{ config, lib, pkgs, inputs, user, ... }:
with lib;
let
  cfg = config.basics'.security;
  inherit (config.home-manager.users.${user}.home) homeDirectory;
in {
  imports = [ inputs.agenix.nixosModules.default ];

  options.basics'.security = {
    enable = mkEnableOption "security config" // { default = true; };
  };

  config = mkIf cfg.enable {
    security = {
      tpm2.enable = true;
      rtkit.enable = true;
      sudo.wheelNeedsPassword = false;
    };

    environment.systemPackages = with pkgs; [ rage age-plugin-yubikey ];

    age.identityPaths = [
      # TODO: add yubikey-yufei
      # "../../../secrets/identities/yubikey-yufei.txt"

      "${homeDirectory}/.ssh/id_ed25519"
    ];
  };
}
