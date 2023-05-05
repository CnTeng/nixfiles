{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.hardware'.wireless;
  inherit (cfg) components;
in {
  options.hardware'.wireless = {
    enable = mkEnableOption "wireless support";
    components =
      mapAttrs
      (_: doc: mkEnableOption (mkDoc doc) // {default = cfg.enable;}) {
        network = "network support";
        bluetooth = "Bluetooth support";
      };
  };

  config = mkMerge [
    (mkIf components.network {
      users.users.${user}.extraGroups = ["networkmanager"];

      networking.networkmanager.enable = true;

      environment.persistence."/persist".directories =
        mkIf config.hardware'.impermanence.enable
        ["/etc/NetworkManager/system-connections"];
    })
    (mkIf components.bluetooth {
      hardware.bluetooth.enable = true;

      services.blueman.enable = true;
    })
  ];
}
