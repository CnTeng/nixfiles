{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.programs'.others;
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
        okular

        # Dict
        ydict

        # Music
        youtube-music

        # Video & Picture
        vlc
        gimp
        krita

        # Office
        wpsoffice-cn
        libreoffice
        drawio

        # Community
        tdesktop
        element-desktop
        discord
        qq

        # Games
        tetrio-desktop

        # Manager
        font-manager
      ];
    };
  };
}
