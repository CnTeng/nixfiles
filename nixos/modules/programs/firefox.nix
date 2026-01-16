{ config, lib, ... }:
let
  cfg = config.programs'.firefox;
in
{
  options.programs'.firefox.enable = lib.mkEnableOption "";

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
    };

    preservation'.user.directories = [
      ".mozilla"
      ".cache/mozilla"
      ".config/mozilla"
    ];
  };
}
