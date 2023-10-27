{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services'.juicity;
in {
  options.services'.juicity.enable = mkEnableOption "juicity";

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [443];

    boot.kernelModules = ["tcp_bbr"];
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "cake";
      "net.core.rmem_max" = 2500000;
      "net.core.wmem_max" = 2500000;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    sops.secrets = {
      CLOUDFLARE_API_KEY.sopsFile = ./secrets.yaml;

      "juicity/uuid".sopsFile = ./secrets.yaml;
      "juicity/password".sopsFile = ./secrets.yaml;
    };

    sops.templates.juicity.content = let
      certDir = config.security.acme.certs."juic.snakepi.xyz".directory;
    in ''
      {
        "listen": ":443",
        "users": {
          "${config.sops.placeholder."juicity/uuid"}": "${config.sops.placeholder."juicity/password"}"
        },
        "certificate": "${certDir}/cert.pem",
        "private_key": "${certDir}/key.pem",
        "congestion_control": "bbr",
        "disable_outbound_udp443": false,
        "log_level": "info"
      }
    '';

    security.acme = {
      acceptTerms = true;
      defaults.email = "yufei.teng@pm.me";
      certs."juic.snakepi.xyz" = {
        dnsProvider = "cloudflare";
        credentialFiles = {
          CF_DNS_API_TOKEN_FILE = config.sops.secrets.CLOUDFLARE_API_KEY.path;
        };
      };
    };

    systemd.services.juicity = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "juicity-server Service";
      serviceConfig = {
        Type = "simple";
        ExecStart =
          getExe' pkgs.juicity "juicity-server"
          + " run -c ${config.sops.templates.juicity.path}"
          + " --disable-timestamp";
        Restart = "on-failure";
      };
    };
  };
}
