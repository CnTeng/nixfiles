{ config, lib, ... }:
let
  cfg = config.services'.sing-box;
in
{
  imports = [
    ./server.nix
    ./client.nix
  ];

  config = lib.mkIf (cfg.server.enable || cfg.client.enable) {
    services.sing-box = {
      enable = true;
      settings.log.level = "error";
    };

    sops.secrets."proxy/password" = {
      sopsFile = ../secrets.yaml;
      restartUnits = [ config.systemd.services.sing-box.name ];
    };

    preservation'.os.directories = [
      {
        directory = "/var/lib/sing-box";
        user = "sing-box";
        group = "sing-box";
        mode = "0700";
      }
    ];
  };
}
