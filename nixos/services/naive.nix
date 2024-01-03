{ config, lib, pkgs, utils, ... }:
with lib;
let
  server = config.services'.naive-server;
  client = config.services'.naive-client;

in {
  options.services'.naive-server.enable = mkEnableOption' { };

  options.services'.naive-client = {
    enable = mkEnableOption' { };
    port = mkOption {
      type = types.port;
      visible = false;
    };
  };

  config = mkIf (server.enable || client.enable) {
    sops.secrets = let
      units = optional server.enable "sing-box.service"
        ++ optional client.enable "naive-client.service";
    in {
      cf-dns01-token = {
        key = "outputs/cf_api_token/value";
        sopsFile = config.sops-file.infra;
        restartUnits = units;
      };

      "naive/user" = {
        sopsFile = ./secrets.yaml;
        restartUnits = units;
      };

      "naive/pass" = {
        sopsFile = ./secrets.yaml;
        restartUnits = units;
      };
    };

    services.sing-box = mkIf server.enable {
      enable = true;
      settings.inbounds = [{
        type = "naive";
        listen = "::";
        listen_port = 443;
        users = [{
          username._secret = config.sops.secrets."naive/user".path;
          password._secret = config.sops.secrets."naive/pass".path;
        }];
        tls = {
          enabled = true;
          server_name = "naive.snakepi.xyz";
          acme = {
            domain = "naive.snakepi.xyz";
            email = "isyufei.teng@gmail.com";
            dns01_challenge = {
              provider = "cloudflare";
              api_token._secret = config.sops.secrets.cf-dns01-token.path;
            };
          };
        };
      }];
    };

    sops.templates.naive-client = mkIf client.enable {
      content = let
        user = config.sops.placeholder."naive/user";
        pass = config.sops.placeholder."naive/pass";
      in ''
        https://${user}:${pass}@naive.snakepi.xyz
      '';
    };

    systemd.services.naive-client = let
      settings = {
        listen = "socks://127.0.0.1:${toString client.port}";
        proxy._secret = config.sops.templates.naive-client.path;
      };
      settingsPath = "/etc/naive/config.json";
    in mkIf client.enable {
      preStart = ''
        umask 0077
        mkdir -p /etc/naive
        ${utils.genJqSecretsReplacementSnippet settings settingsPath}
      '';
      description = "naiveproxy Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${getExe pkgs.naive} --config ${settingsPath}";
      };
    };
  };
}
