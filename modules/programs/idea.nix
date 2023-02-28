{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.programs.idea;
in {
  options.custom.programs.idea = { enable = mkEnableOption "jetbrains idea"; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ jetbrains.jdk jetbrains.idea-community ];
    };
  };
}
