{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.qtcreator;
in
{
  options.gui'.qtcreator.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.qtcreator ];
    };

    environment.persistence."/persist" = {
      users.${user} = {
        files = [ ".config/QtProject.conf" ];
        directories = [
          ".config/clangd"
          ".cache/clangd"

          ".config/QtProject"
          ".cache/QtProject"
        ];
      };
    };
  };
}
