{ config, lib, ... }:
with lib;
let
  cfg = config.desktop'.profiles.variables;
in
{
  options.desktop'.profiles.variables.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      NIXOS_OZONE_WL = "1";
    };
  };
}
