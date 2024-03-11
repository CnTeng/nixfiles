{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.mako;
  inherit (config.desktop'.profiles) palette;
in
{
  options.desktop'.profiles.mako.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    home-manager.users.${user} =
      { config, ... }:
      {
        services.mako = with palette; {
          enable = true;
          backgroundColor = dark_4 + "e6";
          textColor = light_1;
          iconPath = config.gtk.iconTheme.package + "/share/icons/Papirus-Dark";
          borderColor = light_1;
          progressColor = "over " + dark_1;
          margin = "0";
          extraConfig = ''
            outer-margin=5

            [urgency=high]
            border-color=${red_1}
          '';

          width = 300;
          height = 150;
          borderSize = 2;
          borderRadius = 10;
          maxIconSize = 96;
          defaultTimeout = 10000;
          font = "RobotoMono Nerd Font 13";
        };
      };
  };
}
