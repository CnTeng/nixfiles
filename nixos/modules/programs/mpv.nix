{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.programs'.mpv;
in
{
  options.programs'.mpv.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.mpv.enable = true;
    };
  };
}
