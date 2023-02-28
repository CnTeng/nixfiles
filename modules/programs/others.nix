{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.programs.others;
in {
  options.custom.programs.others = {
    enable = mkEnableOption "others applications";
  };

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
        spotify
        spotifywm
        youtube-music

        # Video & Picture
        vlc
        gimp
        krita

        # Office
        libreoffice
        drawio

        # Community
        tdesktop
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
