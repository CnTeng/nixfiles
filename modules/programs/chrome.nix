{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.programs.chrome;
in {
  options.custom.programs.chrome = { enable = mkEnableOption "Chrome"; };

  config = mkIf cfg.enable {
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
  };
}
