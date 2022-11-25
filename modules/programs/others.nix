{ config, pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home = {
      packages = with pkgs; [
        # Password manager
        bitwarden
        bitwarden-cli

        # Reading
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

        # Video & Picture
        vlc
        gimp
        krita

        # Office
        libreoffice

        # Community
        tdesktop
        discord

        # Games
        tetrio-desktop

        # Manager
        font-manager

        # Browser
        microsoft-edge
      ] ++ (with config;[
        nur.repos.yes.electronic-wechat
      ]);
    };
  };
}
