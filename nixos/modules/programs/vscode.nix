{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.programs'.vscode;
in
{
  options.programs'.vscode.enable = lib.mkEnableOption "Visual Studio Code";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode-fhs;
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".config/Code" ];
    };
  };
}
