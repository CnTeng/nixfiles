{ pkgs, user, ... }:

{
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    libva-utils
    xdg-utils # For vscode and idea opening urls
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

  home-manager.users.${user} = {
    programs.firefox = {
      enable = true;
      profiles.${user}.settings = {
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
