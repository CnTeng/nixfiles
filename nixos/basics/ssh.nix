{
  config,
  lib,
  user,
  data,
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
            identityFile = ["${home}/.ssh/id_ed25519_sk_rk_auth@NixOS"];
          }) {
            rxls0 = data.rxls.value.rxls0.ipv4;
            rxhc0 = data.rxhc.value.rxhc0.ipv4;
          };
      };
    };
  };
}
