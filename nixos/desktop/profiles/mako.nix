{ config, lib, user, ... }:
with lib;
let
  cfg = config.desktop'.profiles.mako;
  inherit (config.core'.colors) palette;
in {
  options.desktop'.profiles.mako.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    home-manager.users.${user} = { config, ... }: {
      services.mako = with palette; {
        enable = true;
        backgroundColor = base.hex + "e6";
        textColor = text.hex;
        iconPath = config.gtk.iconTheme.package + "/share/icons/Papirus-Dark";
        borderColor = text.hex;
        progressColor = "over " + surface0.hex;
        margin = "0";
        extraConfig = ''
          outer-margin=5

          [urgency=high]
          border-color=${peach.hex}
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
