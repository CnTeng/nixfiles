{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.thunar;
in {
  options.desktop'.components.thunar.enable = mkEnableOption "thunar";

  config = mkIf cfg.enable {
    services = {
      tumbler.enable = true;
      gvfs.enable = true; # Enable trash

      # Enable USB Automounting
      udisks2.enable = true;
      devmon.enable = true;
    };

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };

    environment.systemPackages = with pkgs; [xfce.ristretto gnome.file-roller];

    home-manager.users.${user}.services.udiskie.enable = true;
  };
}
