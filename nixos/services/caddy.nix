{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.caddy;
in {
  options.services'.caddy.enable = mkEnableOption "Caddy";

  config = mkIf cfg.enable {
    services.caddy.enable = true;

    sops.secrets.cloudflare = {
      owner = config.services.caddy.user;
      sopsFile = ./secrets.yaml;
      restartUnits = ["caddy.service"];
    };
  };
}
