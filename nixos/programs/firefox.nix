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
  inherit (config.hardware') persist;
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

    environment.persistence."/persist" = mkIf persist.enable {
      users.${user}.directories = [ ".mozilla" ];
    };
  };
}
