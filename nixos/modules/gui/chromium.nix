{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.gui'.chromium;
in
{
  options.gui'.chromium.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.chromium = {
        enable = true;
        commandLineArgs = [
          "--enable-features=TouchpadOverscrollHistoryNavigation"
        ];
      };

      xdg.mimeApps.defaultApplications = {
        "text/html" = "chromium-browser.desktop";
        "text/xml" = "chromium-browser.desktop";

        "application/xml" = "chromium-browser.desktop";
        "application/xhtml+xml" = "chromium-browser.desktop";
        "application/xhtml_xml" = "chromium-browser.desktop";
        "application/rdf+xml" = "chromium-browser.desktop";
        "application/rss+xml" = "chromium-browser.desktop";

        "application/x-extension-htm" = "chromium-browser.desktop";
        "application/x-extension-html" = "chromium-browser.desktop";
        "application/x-extension-shtml" = "chromium-browser.desktop";
        "application/x-extension-xht" = "chromium-browser.desktop";
        "application/x-extension-xhtml" = "chromium-browser.desktop";

        "x-scheme-handler/about" = "chromium-browser.desktop";
        "x-scheme-handler/ftp" = "chromium-browser.desktop";
        "x-scheme-handler/http" = "chromium-browser.desktop";
        "x-scheme-handler/https" = "chromium-browser.desktop";
      };
    };

    environment.variables = {
      GOOGLE_DEFAULT_CLIENT_ID = "77185425430.apps.googleusercontent.com";
      GOOGLE_DEFAULT_CLIENT_SECRET = "OTJgUOQcT7lO7GsGZq2G4IlT";
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/chromium"
        ".cache/chromium"
      ];
    };
  };
}
