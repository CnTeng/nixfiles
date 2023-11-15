{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.others;
in {
  options.programs'.others.enable = mkEnableOption "others programs";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        # Password manager
        bitwarden
        bitwarden-cli

        # Reader
        calibre

        # Video & Picture
        vlc
        gimp

        # Office
        drawio

        # Community
        tdesktop
        element-desktop
        discord

        sioyek

        inkscape
      ];
    };
  };
}
