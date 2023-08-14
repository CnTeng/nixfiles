{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.notification;
  inherit (config.desktop'.profiles) palette;
  inherit (config.home-manager.users.${user}.gtk) iconTheme;
in {
  options.desktop'.profiles.notification = {
    enable = mkEnableOption "notification daemon component";
    package =
      mkPackageOption pkgs "notification daemon" {default = ["dunst"];};
  };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      services.mako = with palette; {
        enable = true;
        # Copy from https://github.com/catppuccin/mako
        backgroundColor = "${base.hex}e6";
        textColor = "${text.hex}";
        iconPath = "${iconTheme.package}/share/icons/Papirus-Dark";
        borderColor = "${blue.hex}";
        progressColor = "over ${surface0.hex}";
        margin = "0";
        extraConfig = ''
          outer-margin=5

          [urgency=high]
          border-color=${peach.hex}
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
