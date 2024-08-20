{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.others;
in
{
  options.gui'.others.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        calibre
        foliate
        # element-desktop
        spotify
        tdesktop
        zed-editor
      ];
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".cache/calibre"
        ".config/calibre"

        ".cache/com.github.johnfactotum.Foliate"
        ".local/share/com.github.johnfactotum.Foliate"

        ".config/Element"

        ".cache/spotify"
        ".config/spotify"

        ".cache/TelegramDesktop"
        ".local/share/TelegramDesktop"

        ".config/zed"
        ".local/share/zed"
      ];
    };
  };
}
