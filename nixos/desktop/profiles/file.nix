{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.fileManager;
in {
  options.desktop'.profiles.fileManager = {
    enable = mkEnableOption "file manager component";
    package = mkPackageOption pkgs "file manager" {
      default = ["cinnamon" "nemo-with-extensions"];
    };
  };

  config = mkIf cfg.enable {
    services = {
      gvfs.enable = true;
      dbus.packages = [cfg.package];
    };

    programs = {
      file-roller.enable = true;
      evince.enable = true;
    };

    home-manager.users.${user} = {
      services.udiskie.enable = true;

      home.packages = [cfg.package pkgs.cinnamon.xviewer];

      dconf.settings = {
        "org/cinnamon/desktop/applications/terminal".exec = "kitty";
        "org/nemo/preferences" = {
          close-device-view-on-device-eject = true;
          show-open-in-terminal-toolbar = true;
          show-show-thumbnails-toolbar = true;
          tooltips-in-icon-view = true;
          tooltips-in-list-view = true;
        };
      };
    };
  };
}
