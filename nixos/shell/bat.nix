{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.shell'.bat;

  flavour = toLower config.core'.colors.flavour;
  catppuccin = pkgs.catppuccin.override { variant = flavour; };
in {
  options.shell'.bat.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.bat = {
        enable = true;
        config.theme = "Catppuccin-${flavour}";
        themes."Catppuccin-${flavour}" = {
          src = catppuccin + /bat;
          file = "Catppuccin-${flavour}.tmTheme";
        };
      };
    };
  };
}
