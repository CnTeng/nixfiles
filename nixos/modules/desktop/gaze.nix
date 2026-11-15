{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.desktop'.gaze;
in
{
  imports = [ inputs.gaze.nixosModules.default ];

  options.desktop'.gaze.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.gaze = {
      enable = true;
      settings.cameras = {
        ir = "usb:5986:118c";
        emitter_enabled = true;
        parallel_capture = "auto";
        dark_luma_threshold = 10;
      };
      mutableConfig = false;
      gui.enable = true;
    };

    security.pam.services = {
      greetd.gaze.enable = true;
      gtklock.gaze.enable = true;
    };

    preservation'.os.directories = [
      {
        directory = "/var/lib/gaze";
        mode = "0700";
      }
      "/var/cache/gaze"
    ];
  };
}
