{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services'.naive;
in {
  options.services'.naive.enable = mkEnableOption "naive";

  config = mkIf cfg.enable {
    services'.caddy.enable = true;

    services.caddy.extraConfig = ''
      :443, ${config.networking.hostName}.snakepi.xyz {

      	tls yufei.teng@pm.me

        import ${config.sops.secrets."naive/server".path}
      }
    '';

    sops.secrets."naive/server" = {
      owner = "caddy";
      sopsFile = ./secrets.yaml;
    };
  };
}
