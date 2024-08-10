{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.cosmic.profiles.theme;
in
{
  options.cosmic.profiles.theme.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} =
      { config, ... }:
      {
        qt = {
          enable = true;
          style.name = "adwaita-dark";
        };

        gtk = {
          enable = true;
          font.name = "NotoSans Nerd Font";
          iconTheme = {
            package = pkgs.papirus-icon-theme;
            name = "Papirus-Dark";
          };
          theme = {
            package = pkgs.adw-gtk3;
            name = "adw-gtk3-dark";
          };
          gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        };
      };
  };
}
