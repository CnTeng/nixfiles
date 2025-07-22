{
  config,
  lib,
  ...
}:
let
  cfg = config.gui'.chromium;
  inherit (config.core') user;
in
{
  options.gui'.chromium.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.chromium = {
        enable = true;
        commandLineArgs = [
          "--enable-features=TouchpadOverscrollHistoryNavigation"
        ];
      };
    };

    environment.variables = {
      GOOGLE_DEFAULT_CLIENT_ID = "77185425430.apps.googleusercontent.com";
      GOOGLE_DEFAULT_CLIENT_SECRET = "OTJgUOQcT7lO7GsGZq2G4IlT";
    };

    preservation.preserveAt."/persist" = {
      users.${user}.directories = [
        ".cache/chromium"
        ".config/chromium"
      ];
    };
  };
}
