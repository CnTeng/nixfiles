{ config, lib, user, pkgs, ... }:
with lib;
let
  cfg = config.desktop'.components.notification;
  inherit (config.basics') colorScheme;
  inherit (config.home-manager.users.${user}.gtk) iconTheme;
in {
  options.desktop'.components.notification = {
    enable = mkEnableOption "notification daemon component" // {
      default = config.desktop'.hyprland.enable;
    };
    package =
      mkPackageOption pkgs "notification daemon" { default = [ "dunst" ]; };
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.mako = {
        enable = true;
        # Copy from https://github.com/catppuccin/mako
        backgroundColor = "#${colorScheme.base}e6";
        textColor = "#${colorScheme.text}";
        iconPath = "${iconTheme.package}/share/icons/Papirus-Dark";
        borderColor = "#${colorScheme.blue}";
        progressColor = "over #${colorScheme.surface0}";
        margin = "0";
        extraConfig = ''
          outer-margin=5

          [urgency=high]
          border-color=#${colorScheme.peach}
        '';

        width = 400;
        height = 150;
        borderSize = 4;
        borderRadius = 10;
        maxIconSize = 96;
        defaultTimeout = 10000;
        font = "RobotoMono Nerd Font 14";
      };
    };
  };
}
