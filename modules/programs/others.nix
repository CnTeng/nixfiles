{ pkgs, user, ... }:

{
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
}
