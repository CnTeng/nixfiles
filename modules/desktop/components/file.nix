{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.desktop'.components.fileManager;
in {
  options.desktop'.components.fileManager = {
    enable = mkEnableOption "file manager component" // {
      default = config.desktop'.hyprland.enable;
    };
    package = mkPackageOption pkgs "file manager" {
      default = [ "cinnamon" "nemo-with-extensions" ];
    };
  };

  config = mkIf cfg.enable {
    programs.file-roller.enable = true;

    services.dbus.packages = [ cfg.package ];

    home-manager.users.${user} = {
      home.packages = [ cfg.package pkgs.cinnamon.xviewer ];

      dconf.settings = {
        "org/cinnamon/desktop/applications/terminal".exec = "kitty";
      };
    };
  };
}
