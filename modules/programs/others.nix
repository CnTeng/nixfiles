{ config, pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home = {
      packages = with pkgs; [
        # Reading
        # Use pkgs.wdisplays align the single screen to the top
        # or place the specified output at 0 0 in sway config
        # for okular menu bar working successfully
        okular
        foliate

        # Dict
        ydict

        # Music
        spotify
        spotifywm

        # Video & Picture
        ffmpeg
        vlc
        gimp
        krita

        bitwarden
        bitwarden-cli

        # Office
        libreoffice

        # Community
        tdesktop
        discord

        # Games
        tetrio-desktop

        # Manager
        font-manager

        microsoft-edge
      ] ++ (with config;[
        nur.repos.yes.electronic-wechat
      ]);
    };
  };
}
