{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.components.clipboard;
in {
  options.desktop'.components.clipboard.enable =
    mkEnableOption "clipboard and clipboard manager";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [pkgs.wl-clipboard];
      services.clipman = {
        enable = true;
        systemdTarget = "hyprland-session.target";
      };
    };
  };
}
