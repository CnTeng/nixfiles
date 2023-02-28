{ config, lib, pkgs, user, ... }:

with lib;

let
  cfg = config.shell.proxy;

  naive = pkgs.naiveproxy;
  configFile = config.age.secrets.naiveConfig.path;
in {
  options.shell.proxy.naive = {
    enable = mkEnableOption "naive proxy" // { default = cfg.enable; };
  };

  config = mkIf cfg.naive.enable {

    environment.systemPackages = [ pkgs.naiveproxy ];

    systemd.services.naiveproxy = {
      description = "naiveproxy Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${naive}/bin/naive --config ${configFile}";
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
