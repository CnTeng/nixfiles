{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Password manager
      bitwarden
      bitwarden-cli

      # Reader
      # Use pkgs.wdisplays align the single screen to the top
      # or place the specified output at 0 0 in sway config
      # for okular menu bar working successfully
      okular
      foliate
      calibre

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
