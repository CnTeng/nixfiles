{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.chrome;
in
{
  options.programs'.chrome.enable = mkEnableOption "Chrome";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {

      programs.google-chrome = {
        enable = true;
        commandLineArgs = [ "--enable-wayland-ime" ];
      };
    };
  };
}
