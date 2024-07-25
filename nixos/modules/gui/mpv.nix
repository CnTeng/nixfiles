{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.gui'.mpv;
in
{
  options.gui'.mpv.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.mpv.enable = true;
    };
  };
}
