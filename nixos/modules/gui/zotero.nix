{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.zotero;
in
{
  options.gui'.zotero.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.zotero ];
    };

    preservation.preserveAt."/persist" = {
      users.${user}.directories = [
        ".cache/zotero"
        ".local/share/zotero"
        ".zotero"
      ];
    };
  };
}
