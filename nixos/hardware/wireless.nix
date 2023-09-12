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
      # networking.useNetworkd = true;
      # systemd.network.enable = true;

      environment.persistence."/persist".directories =
        mkIf config.hardware'.stateless.enable
        ["/etc/NetworkManager/system-connections"];
    })

    (mkIf components.bluetooth {
      hardware.bluetooth.enable = true;

      services.blueman.enable = true;
    })
  ];
}
