{ config, lib, ... }:
let
  cfg = config.services'.tailscale;

  inherit (config.core') hostName;
in
{
  options.services'.tailscale.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.sops.secrets.tailnet_key.path;
    };

    sops.secrets.tailnet_key = {
      key = "hosts/${hostName}/tailnet_key";
      restartUnits = [ config.systemd.services.tailscaled.name ];
    };

    preservation.preserveAt."/persist".directories = [
      "/var/cache/tailscale"
      "/var/lib/tailscale"
    ];
  };
}
