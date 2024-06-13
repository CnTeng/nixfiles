{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.cosmic.profiles.xdg;

in
{
  options.cosmic.profiles.xdg.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.onedrive.enable = true;

    systemd.user.services.onedrive-launcher = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = lib.mkForce [ "graphical-session.target" ];
    };

    home-manager.users.${user} = {
      xdg.mimeApps.enable = true;
    };
  };
}
