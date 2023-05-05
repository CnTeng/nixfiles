{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs'.kdeconnect;
in {
  options.programs'.kdeconnect.enable = mkEnableOption "KDE connect";

  config = mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.valent;
    };
    services.dbus.packages = [pkgs.valent];
  };
}
