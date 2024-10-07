{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.services'.mega;
in
{
  options.services'.mega.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ megacmd ];

    systemd.services = {
      mega-cmd = {
        description = "MEGA cmd server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "on-failure";
          User = user;
          Group = "users";
          ExecStart = lib.getExe' pkgs.megacmd "mega-cmd-server";
        };
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".megaCmd" ];
    };
  };
}
