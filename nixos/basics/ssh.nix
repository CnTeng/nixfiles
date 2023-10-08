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
        forwardAgent = true;
        matchBlocks = let
          mapBlock = n: {
            # inherit user;
            hostname = "${n}.snakepi.xyz";
            identityFile = ["${home}/.ssh/id_ed25519_sk_rk_auth@NixOS"];
          };
        in {
          rxls0 = mapBlock "rxls0";
          rxhc0 = mapBlock "rxhc0";
        };
      };
    };
  };
}
