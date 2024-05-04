{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.programs'.qtcreator;
in
{
  options.programs'.qtcreator.enable = lib.mkEnableOption "Qt Creator";

  config = lib.mkIf cfg.enable {
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
