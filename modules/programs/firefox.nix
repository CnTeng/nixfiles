{ config, lib, ... }:

with lib;

let cfg = config.custom.programs.firefox;
in {
  options.custom.programs.firefox = { enable = mkEnableOption "firefox"; };

  config = mkIf cfg.enable {
    # Enable wayland support for firefox
    environment.sessionVariables = { MOZ_ENABLE_WAYLAND = "1"; };

    programs.firefox = {
      enable = true;
      languagePacks = [ "en-US" "zh-CN" ];
      preferences = {
        "intl.accept_languages" = "zh-cn,en-us";
        "intl.locale.requested" = "zh-cn";
        "extensions.pocket.enabled" = false;
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "browser.download.dir" = "~/Downloads";
      };
    };
  };
}
