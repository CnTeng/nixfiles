{ config, lib, user, ... }:
with lib;
let
  cfg = config.basics'.ssh;
  inherit (config.home-manager.users.${user}.home) homeDirectory;
in {
  options.basics'.ssh = {
    enable = mkEnableOption "ssh config" // { default = true; };
  };

  config = mkIf cfg.enable {
    programs.ssh.startAgent = true;

    home-manager.users.${user} = {
      programs.ssh = {
        enable = true;
        matchBlocks = mapAttrs (name: ip: {
          hostname = "${ip}";
          port = 22;
          user = "yufei";
          forwardAgent = true;
          identityFile =
            [ "${homeDirectory}/.ssh/id_ed25519_sk_rk_${name}@NixOS" ];
        }) {
          rxaws = "13.113.148.152";
          rxhz = "78.47.24.36";
        };
      };
    };
  };
}
