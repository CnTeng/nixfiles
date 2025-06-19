{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.anki;
in
{
  options.gui'.anki.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.anki ];
    };

    preservation.preserveAt."/persist" = {
      users.${user}.directories = [
        ".cache/Anki"
        ".local/share/Anki2"
      ];
    };
  };
}
