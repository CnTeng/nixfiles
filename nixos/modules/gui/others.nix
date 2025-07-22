{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gui'.others;
  inherit (config.core') user;
in
{
  options.gui'.others.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        calibre
        spotify
        tdesktop

        asciinema
        asciinema-agg
      ];
    };

    preservation.preserveAt."/persist" = {
      users.${user}.directories = [
        ".cache/calibre"
        ".config/calibre"

        ".cache/spotify"
        ".config/spotify"

        ".cache/TelegramDesktop"
        ".local/share/TelegramDesktop"
      ];
    };
  };
}
