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

        # Dict
        ydict

        # Music
        youtube-music

        # Video & Picture
        vlc
        gimp

        # Office
        libreoffice
        drawio

        # Community
        tdesktop
        element-desktop
        discord
        qq

        # Manager
        font-manager

        ffmpeg

        thunderbird

        planify

        todoist

        todoist-electron

        sioyek
      ];
    };
  };
}
