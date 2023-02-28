{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.programs.vscode;
in {
  options.custom.programs.vscode = { enable = mkEnableOption "vscode"; };

  config = mkIf cfg.enable {
    # environment.sessionVariables = {
    #   NIXOS_OZONE_WL = "1";
    # };

    home-manager.users.${user} = {
      # For logining the Microsoft in vscode
      services.gnome-keyring = {
        enable = true;
        components = [ "secrets" ];
      };

      programs.vscode = {
        enable = true;
        package = pkgs.vscode-fhs;
      };
    };
  };
}
