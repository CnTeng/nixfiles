{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.hardware'.devices;
  inherit (cfg) components;
in {
  options.hardware'.devices = {
    enable = mkEnableOption "all devices support";
    components =
      mapAttrs
      (_: doc: mkEnableOption (mkDoc doc) // {default = cfg.enable;}) {
        audio = "audio support";
        light = "light support";
      };
  };

  config = mkIf cfg.enable (mkMerge [
    {users.users.${user}.extraGroups = ["camera"];}

    (mkIf components.audio {
      users.users.${user}.extraGroups = ["audio"];

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
    })

    (mkIf components.light {
      users.users.${user}.extraGroups = ["video"];

      programs.light.enable = true;

      location.provider = "geoclue2";

      # services = {
      #   # use Ambient Light Sensors for auto brightness adjustment
      #   clight = {
      #     enable = true;
      #     settings = {
      #       verbose = true;
      #       dpms.timeouts = [900 300];
      #       dimmer.timeouts = [870 270];
      #       screen.disabled = true;
      #     };
      #   };
      # };
    })
  ]);
}
