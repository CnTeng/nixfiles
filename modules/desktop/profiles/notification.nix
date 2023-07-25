{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.notification;
  inherit (config.desktop'.profiles) colorScheme;
  inherit (config.home-manager.users.${user}.gtk) iconTheme;
in {
  options.desktop'.profiles.notification = {
    enable = mkEnableOption "notification daemon component";
    package =
      mkPackageOption pkgs "notification daemon" {default = ["dunst"];};
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.mako = with colorScheme; {
        enable = true;
        # Copy from https://github.com/catppuccin/mako
        backgroundColor = "${base}e6";
        textColor = "${text}";
        iconPath = "${iconTheme.package}/share/icons/Papirus-Dark";
        borderColor = "${blue}";
        progressColor = "over ${surface0}";
        margin = "0";
        extraConfig = ''
          outer-margin=5

          [urgency=high]
          border-color=${peach}
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
