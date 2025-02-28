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
        commandLineArgs = [
          "--enable-wayland-ime"
          "--enable-features=TouchpadOverscrollHistoryNavigation"
        ];
      };

      xdg.mimeApps.defaultApplications = {
        "text/html" = "google-chrome.desktop";
        "text/xml" = "google-chrome.desktop";

        "application/xml" = "google-chrome.desktop";
        "application/xhtml+xml" = "google-chrome.desktop";
        "application/xhtml_xml" = "google-chrome.desktop";
        "application/rdf+xml" = "google-chrome.desktop";
        "application/rss+xml" = "google-chrome.desktop";

        "application/x-extension-htm" = "google-chrome.desktop";
        "application/x-extension-html" = "google-chrome.desktop";
        "application/x-extension-shtml" = "google-chrome.desktop";
        "application/x-extension-xht" = "google-chrome.desktop";
        "application/x-extension-xhtml" = "google-chrome.desktop";

        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/ftp" = "google-chrome.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/google-chrome"
        ".cache/google-chrome"
      ];
    };
  };
}
