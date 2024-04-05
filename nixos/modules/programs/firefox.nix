{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.firefox;
in
{
  options.programs'.firefox.enable = mkEnableOption "Firefox";

  config = mkIf cfg.enable {
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
        "intl.accept_languages" = "zh-cn,en-us";
        "intl.locale.requested" = "zh-cn";
        # "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
      };
      languagePacks = [
        "en-US"
        "zh-CN"
      ];
      nativeMessagingHosts.packages = [ pkgs.tridactyl-native ];
    };

    home-manager.users.${user} = {
      xdg.mimeApps.defaultApplications = {
        "text/html" = "firefox.desktop";
        "text/xml" = "firefox.desktop";
        "application/x-extension-htm" = [ "firefox.desktop" ];
        "application/x-extension-html" = [ "firefox.desktop" ];
        "application/x-extension-shtml" = [ "firefox.desktop" ];
        "application/x-extension-xht" = [ "firefox.desktop" ];
        "application/x-extension-xhtml" = [ "firefox.desktop" ];
        "application/xhtml+xml" = "firefox.desktop";
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
