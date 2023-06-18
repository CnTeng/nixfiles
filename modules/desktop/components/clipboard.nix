{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.desktop'.components.clipboard;
in {
  options.desktop'.components.clipboard.enable =
    mkEnableOption "clipboard component" // {
      default = config.desktop'.hyprland.enable;
    };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.wl-clipboard ];

      services.clipman.enable = true;
    };
  };
}
