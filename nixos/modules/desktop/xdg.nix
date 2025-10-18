{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop'.xdg;

  default = {
    terminal = pkgs.kitty;
    editor = pkgs.neovim;
    browser = pkgs.chromium;
    archiver = pkgs.file-roller;
    fileManager = pkgs.nautilus;
    imageViewer = pkgs.eog;
    office = pkgs.libreoffice-fresh;
  };
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
        defaultApplicationPackages = [
          default.terminal
          default.editor
          default.browser
          default.archiver
          default.fileManager
          default.imageViewer
          default.office
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
