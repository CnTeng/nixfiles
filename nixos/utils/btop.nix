{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.utils'.btop;

  flavour = toLower config.core'.colors.flavour;
  catppuccin = pkgs.catppuccin.override { variant = flavour; };
in
{
  options.utils'.btop.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      xdg.configFile."btop/themes".source = catppuccin + /btop;

      programs.btop = {
        enable = true;
        settings = {
          color_theme = "catppuccin_${flavour}.theme";
          theme_background = false;
          vim_keys = true;
        };
      };
    };
  };
}
