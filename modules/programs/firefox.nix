{ pkgs, user, ... }:

{
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    libva-utils
  ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-ocl
      # vaapiIntel
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      # vaapiIntel
    ];
  };

  # Enable wayland support for firefox
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

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
}
