{ config, lib, ... }:
let
  cfg = config.programs'.chromium;
in
{
  options.programs'.chromium.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm' = {
      programs.chromium = {
        enable = true;
        commandLineArgs = [
          "--enable-features=TouchpadOverscrollHistoryNavigation"
        ];
      };

      home.sessionVariables = {
        GOOGLE_DEFAULT_CLIENT_ID = "77185425430.apps.googleusercontent.com";
        GOOGLE_DEFAULT_CLIENT_SECRET = "OTJgUOQcT7lO7GsGZq2G4IlT";
      };
    };

    preservation'.user.directories = [
      ".cache/chromium"
      ".config/chromium"
    ];
  };
}
