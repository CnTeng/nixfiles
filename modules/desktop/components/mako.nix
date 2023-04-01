{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.desktop'.components.mako;
  inherit (config.basics') colorScheme;
in {
  options.desktop'.components.mako.enable = mkEnableOption "mako";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.jq ];

      services.mako = {
        enable = true;
        # Copy from https://github.com/catppuccin/mako
        backgroundColor = "#${colorScheme.base}e6";
        textColor = "#${colorScheme.text}";
        borderColor = "#${colorScheme.blue}";
        progressColor = "over #${colorScheme.surface0}";
        extraConfig = ''
          [urgency=high]
          border-color=#${colorScheme.peach}
        '';

        width = 400;
        height = 150;
        margin = "5";
        borderSize = 4;
        borderRadius = 10;
        maxIconSize = 96;
        defaultTimeout = 10000;
        font = "RobotoMono Nerd Font 14";
      };
    };
  };
}
