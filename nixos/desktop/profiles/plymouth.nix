{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.plymouth;

  flavour = toLower config.basics'.colors.flavour;
in {
  options.desktop'.profiles.plymouth.enable =
    mkEnableOption "login manager component";

  config = mkIf cfg.enable {
    boot = {
      initrd.verbose = false;
      consoleLogLevel = 0;
      kernelParams = ["quiet" "udev.log_level=3"];

      plymouth = {
        enable = true;
        themePackages = [
          (pkgs.catppuccin-plymouth.override {
            variant = flavour;
          })
        ];
        theme = "catppuccin-${flavour}";
      };
    };
  };
}
