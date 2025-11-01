{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs'.telegram;
in
{
  options.programs'.telegram.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.home.packages = [ pkgs.telegram-desktop ];

    preservation'.user.directories = [
      ".cache/TelegramDesktop"
      ".local/share/TelegramDesktop"
    ];
  };
}
