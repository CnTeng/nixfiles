{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.xdg;
in
{
  options.desktop'.profiles.xdg.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      xdg.enable = true;
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
      };
    };

    xdg.mime = {
      enable = true;
      defaultApplications = {
        "application/xhtml+xml" = "firefox.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "text/*" = "nvim-kitty.desktop";
        "text/html" = "firefox.desktop";
        "text/xml" = "firefox.desktop";
        "image/*" = "xviewer.desktop";
        "x-scheme-handler/terminal" = "kitty.desktop";
        "application/x-sh" = "kitty-open.desktop";
        "application/x-shellscript" = [
          "kitty-open.desktop"
          "nvim-kitty.desktop"
        ];
      };
    };

    environment.persistence."/persist" = mkIf config.hardware'.persist.enable {
      users.${user}.directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Projects"
        "Public"
        "Templates"
        "Videos"
      ];
    };
  };
}
