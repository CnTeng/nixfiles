{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop'.xdg;
in
{
  options.desktop'.xdg.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' = {
      xdg.userDirs.enable = true;

      xdg.terminal-exec = {
        enable = true;
        settings.default = [ "kitty.desktop" ];
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplicationPackages = with pkgs; [
          kitty
          neovim
          file-roller
          nautilus
          loupe
          chromium
        ];
      };
    };

    preservation'.user.directories = [
      "Documents"
      "Downloads"
      "Pictures"
    ];
  };
}
