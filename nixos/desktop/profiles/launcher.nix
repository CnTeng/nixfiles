{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.launcher;
  inherit (config.desktop'.profiles) palette;
in
{
  options.desktop'.profiles.launcher.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    home-manager.users.${user} =
      { config, ... }:
      {
        home.packages = [ pkgs.tofi ];
        xdg.configFile."tofi/config".text = with palette; ''
          font = RobotoMono Nerd Font
          font-size = 12

          width = 100%
          height = 50
          background-color = ${dark_0}

          anchor = top
          fuzzy-match = true

          horizontal = true
          prompt-text = " Run: "
          outline-width = 0
          border-width = 0
          min-input-width = 120
          result-spacing = 15
          corner-radius = 10
          margin-top = 30
        '';

        wayland.windowManager.sway.config.menu = getExe' pkgs.tofi "tofi-drun" + " | xargs swaymsg exec --";
      };

    environment.persistence."/persist" = {
      users.${user}.files = [
        ".cache/tofi-compgen"
        ".cache/tofi-drun"
        ".local/state/tofi-drun-history"
        ".local/state/tofi-history"
      ];
    };
  };
}
