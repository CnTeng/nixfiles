{
  config,
  lib,
  ...
}:
let
  cfg = config.services'.tailscale;

  inherit (config.networking) hostName;
in
{
  options.services'.tailscale.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailnet_key.path;
    };

    sops.secrets.tailnet_key = {
      key = "hosts/${hostName}/tailnet_key";
      restartUnits = [ "tailscaled.service" ];
    };
  };
}
