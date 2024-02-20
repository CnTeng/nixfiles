{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.utils'.btop;
in
{
  options.utils'.btop.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.btop = {
        enable = true;
        settings = {
          theme_background = false;
          vim_keys = true;
        };
      };
    };
  };
}
