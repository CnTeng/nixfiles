{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.basics'.ssh;
  inherit (config.users.users.${user}) home;
in {
  options.basics'.ssh.enable =
    mkEnableOption "ssh config" // {default = true;};

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.ssh = {
        enable = true;
        matchBlocks =
          mapAttrs (name: ip: {
            port = 22;
            forwardAgent = true;
            user = "yufei";
            hostname = "${ip}";
            identityFile = ["${home}/.ssh/id_ed25519_sk_rk_${name}@NixOS"];
          }) {
            rxaws = "13.113.148.152";
            rxhz = "49.13.50.247";
          };
      };
    };
  };
}
