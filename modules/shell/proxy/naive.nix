{ config, lib, pkgs, user, ... }:

with lib;

let
  cfg = config.custom.shell.proxy;
  inherit (config.age.secrets.naiveConfig) path;
in {
  options.custom.shell.proxy.naive = {
    enable = mkEnableOption "naive proxy" // { default = cfg.enable; };
  };

  config = mkIf cfg.naive.enable {
    environment.systemPackages = [ pkgs.naiveproxy ];

    systemd.services.naiveproxy = {
      description = "naiveproxy Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.naiveproxy}/bin/naive --config ${path}";
      };
    };

    age.secrets.naiveConfig = {
      file = ../../../secrets/laptop/naiveConfig.age;
      owner = "${user}";
      group = "users";
      mode = "644";
    };
  };
}
