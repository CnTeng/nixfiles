{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.services'.calibre;
  port = 5222;
in
{
  options.services'.calibre.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ port ];

    services.calibre-server = {
      enable = true;
      libraries = [ "/home/${user}/OneDrive/Calibre" ];
      user = user;
      group = "users";
      inherit port;
    };

    services.caddy.virtualHosts."book.snakepi.xyz" = {
      logFormat = "output stdout";
      extraConfig = ''
        import ${config.sops.templates.cf-tls.path}

        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };
}
