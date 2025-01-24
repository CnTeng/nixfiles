{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.gui'.firefox;
in
{
  options.gui'.firefox.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        DisableAppUpdate = true;
        DisablePocket = true;
        DisableSetDesktopBackground = true;
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        Homepage = {
          URL = "about:home";
          Locked = true;
          StartPage = "homepage";
        };
        NoDefaultBookmarks = true;
        PasswordManagerEnabled = false;
        SearchBar = "unified";
        SearchSuggestEnabled = true;
        ShowHomeButton = false;
      };
      preferences = {
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };

    home-manager.users.${user} = {
      xdg.mimeApps.defaultApplications = {
        "text/html" = "firefox.desktop";
        "text/xml" = "firefox.desktop";

        "application/xml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/xhtml_xml" = "firefox.desktop";
        "application/rdf+xml" = "firefox.desktop";
        "application/rss+xml" = "firefox.desktop";

        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";

        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".mozilla"
        ".cache/mozilla"
      ];
    };
  };
}
