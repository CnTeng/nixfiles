{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hardware'.devices;
in {
  options.hardware'.devices.enable = mkEnableOption "devices support";

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = ["camera" "video" "audio" "i2c"];

    hardware.i2c.enable = true;

    hardware.openrazer = {
      enable = true;
      users = [user];
    };

    environment.systemPackages = [pkgs.ddcutil];

    hardware.brillo.enable = true;

    sound = {
      enable = true;
      mediaKeys.enable = true;
    };

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    services.fstrim.enable = true;
  };
}
