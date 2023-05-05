{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.obs;
in {
  options.programs'.obs = {
    enable = mkEnableOption "OBS Studio";
    v4l2Support =
      mkEnableOption "v4l2loopback support for creating virtual camera"
      // {
        default = cfg.enable;
      };
  };

  config = mkIf cfg.enable {
    boot = mkIf cfg.v4l2Support {
      kernelModules = ["v4l2loopback"];

      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];

      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
      '';
    };

    home-manager.users.${user} = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs; [obs-studio-plugins.wlrobs];
      };
    };
  };
}
