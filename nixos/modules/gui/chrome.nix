{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.gui'.chrome;
in
{
  options.gui'.chrome.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.google-chrome = {
        enable = true;
        commandLineArgs = [ "--enable-wayland-ime" ];
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/google-chrome"
        ".cache/chromium"
        ".cache/google-chrome"
      ];
    };
  };
}
