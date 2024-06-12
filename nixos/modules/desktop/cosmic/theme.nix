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
    boot.plymouth.enable = true;

    home-manager.users.${user} = {
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
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };
  };
}
