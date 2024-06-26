{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.programs'.wps;
in
{
  options.programs'.wps.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      ttf-ms-win10
      ttf-wps-fonts
    ];

    home-manager.users.${user} = {
      home.packages = [ pkgs.wpsoffice-cn ];
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/Kingsoft"
        ".local/share/Kingsoft"
      ];
    };
  };
}
