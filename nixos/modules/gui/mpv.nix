{
  config,
  lib,
  ...
}:
let
  cfg = config.gui'.mpv;
  inherit (config.core') user;
in
{
  options.gui'.mpv.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.mpv.enable = true;
    };
  };
}
