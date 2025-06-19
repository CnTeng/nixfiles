{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.office;
in
{
  options.gui'.office.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    fonts.packages = [ pkgs.ttf-wps-fonts ];

    home-manager.users.${user} = {
      home.packages = [ pkgs.wpsoffice-cn ];
    };

    preservation.preserveAt."/persist" = {
      users.${user}.directories = [
        ".config/Kingsoft"
        ".local/share/Kingsoft"
      ];
    };
  };
}
