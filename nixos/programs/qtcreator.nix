{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.qtcreator;
in
{
  options.programs'.qtcreator.enable = mkEnableOption "Qt Creator";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.qtcreator ];
    };

    environment.persistence."/persist" = {
      users.${user} = {
        files = [ ".config/QtProject.conf" ];
        directories = [
          ".config/clangd"
          ".config/QtProject"
          ".cache/clangd"
          ".cache/QtProject"
        ];
      };
    };
  };
}
