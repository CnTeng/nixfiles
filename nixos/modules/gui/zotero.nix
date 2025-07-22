{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gui'.zotero;
in
{
  options.gui'.zotero.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.home.packages = [ pkgs.zotero ];

    preservation'.user.directories = [
      ".cache/zotero"
      ".local/share/zotero"
      ".zotero"
    ];
  };
}
