{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.utils'.bat;
in
{
  options.utils'.bat.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.bat = {
        enable = true;
        config.theme = "OneHalfDark";
      };
    };
  };
}
