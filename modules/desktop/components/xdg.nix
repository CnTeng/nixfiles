{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.components.xdg;
in {
  options.desktop'.components.xdg.enable =
    mkEnableOption "xdg component" // {default = true;};

  config = mkMerge [
    (mkIf cfg.enable {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
      };

      home-manager.users.${user} = {
        xdg.enable = true;
        xdg.userDirs = {
          enable = true;
          createDirectories = true;
        };

        # For vscode and idea opening urls
        home.packages = [pkgs.xdg-utils];
      };

      xdg.mime = {
        enable = true;
        defaultApplications = {
          "application/xhtml+xml" = "firefox.desktop";
          "x-scheme-handler/ftp" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "text/*" = "nvim.desktop";
          "text/html" = "firefox.desktop";
          "text/xml" = "firefox.desktop";
          "image/*" = "xviewer.desktop";
          "x-scheme-handler/terminal" = "kitty.desktop";
          "application/x-sh" = "kitty-open.desktop";
          "application/x-shellscript" = [
            "kitty-open.desktop"
            "nvim.desktop"
          ];
        };
      };
    })

    (mkIf config.hardware'.stateless.enable {
      environment.persistence."/persist" = {
        users.${user}.directories = [
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Public"
          "Templates"
          "Videos"
        ];
      };
    })
  ];
}
