{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gui'.others;
in
{
  options.gui'.others.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.home.packages = with pkgs; [
      calibre
      spotify
      tdesktop

      asciinema
      asciinema-agg
    ];

    preservation'.user.directories = [
      ".cache/calibre"
      ".config/calibre"

      ".cache/spotify"
      ".config/spotify"

      ".cache/TelegramDesktop"
      ".local/share/TelegramDesktop"
    ];
  };
}
