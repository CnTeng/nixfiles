{ config, lib, user, ... }:

with lib;

let
  cfg = config.custom.basics.ssh;
  inherit (config.home-manager.users.${user}.home) homeDirectory;
in {
  options.custom.basics.ssh = {
    enable = mkEnableOption "ssh config" // { default = true; };
  };

  config = mkIf cfg.enable {
    programs.ssh.startAgent = true;

    home-manager.users.${user} = {
      programs.ssh = {
        enable = true;
        matchBlocks.rxaws = {
          hostname = "13.113.148.152";
          port = 22;
          user = "yufei";
          forwardAgent = true;
          identityFile =
            [ "${homeDirectory}/.ssh/id_ed25519_sk_rk_rxaws@NixOS" ];
        };
        matchBlocks.rxhz = {
          hostname = "78.47.24.36";
          port = 22;
          user = "yufei";
          forwardAgent = true;
          identityFile =
            [ "${homeDirectory}/.ssh/id_ed25519_sk_rk_rxhz@NixOS" ];
        };
        matchBlocks.rxtx = {
          hostname = "43.134.194.35";
          port = 22;
          user = "yufei";
          forwardAgent = true;
          identityFile =
            [ "${homeDirectory}/.ssh/id_ed25519_sk_rk_rxtx@NixOS" ];
        };
      };
    };
  };
}
