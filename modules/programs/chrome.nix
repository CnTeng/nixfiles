{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome.override {
        commandLineArgs = [
          "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
          "--use-gl=egl"
          "--disable-features=UseChromeOSDirectVideoDecoder"
        ];
      };
    };
  };
}
