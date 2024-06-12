{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.programs'.others;
in
{
  options.programs'.others.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        calibre
        drawio
        foliate
        element-desktop
        inkscape
        spotify
        tdesktop
        vlc
        zed-editor
      ];
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".cache/calibre"
        ".config/calibre"

        ".config/draw.io"

        ".cache/com.github.johnfactotum.Foliate"
        ".local/share/com.github.johnfactotum.Foliate"

        ".config/Element"

        ".cache/inkscape"
        ".cache/inkscape-extension-manager"
        ".config/inkscape"

        ".cache/spotify"
        ".config/spotify"

        ".cache/TelegramDesktop"
        ".local/share/TelegramDesktop"

        ".cache/vlc"
        ".config/vlc"

        ".config/zed"
        ".local/share/zed"
      ];
    };
  };
}
