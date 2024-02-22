{
  config,
  lib,
  utils,
  pkgs,
  ...
}:
with lib;
let
  inherit (config.services'.naive) server client;
in
{
  options.services'.naive = {
    server.enable = mkEnableOption' { };
    client.enable = mkEnableOption' { };
  };

  config = mkIf (server.enable || client.enable) {
    sops.secrets = {
      "naive/user".sopsFile = ./secrets.yaml;
      "naive/pass".sopsFile = ./secrets.yaml;
    };

    sops.templates =
      let
        user = config.sops.placeholder."naive/user";
        pass = config.sops.placeholder."naive/pass";
      in
      {
        naive-server = mkIf server.enable {
          content = "basic_auth ${user} ${pass}";
          owner = config.services.caddy.user;
        };
        naive-client = mkIf client.enable { content = "https://${user}:${pass}@lssg.snakepi.xyz"; };
      };

    services.caddy = mkIf server.enable {
      globalConfig = "order forward_proxy before reverse_proxy";
      virtualHosts.":443, ${config.networking.hostName}.snakepi.xyz" = {
        logFormat = "output stdout";
        extraConfig = ''
          tls rxsnakepi@gmail.com

          forward_proxy {
            import ${config.sops.templates.naive-server.path}
            hide_ip
            hide_via
            probe_resistance
          }
        '';
      };
    };

    systemd.services =
      let
        mkNaiveClient = name: port: {
          "naive-${name}" =
            let
              settings = {
                listen = "socks://127.0.0.1:${toString port}";
                proxy._secret = config.sops.templates.naive-client.path;
              };
              settingsPath = "/etc/naive/config.json";
            in
            {
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
      in
      mkIf client.enable (mkNaiveClient "lssg" 1081);
  };
}
