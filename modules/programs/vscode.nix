{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.vscode;
in {
  options.programs'.vscode.enable = mkEnableOption "Visual Studio Code";

  config = mkIf cfg.enable {
    # environment.sessionVariables = {
    #   NIXOS_OZONE_WL = "1";
    # };

    home-manager.users.${user} = {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode-fhs;
      };
    };
  };
}
