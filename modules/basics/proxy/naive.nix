{ pkgs, config, user, ... }:

let
  naive = pkgs.naiveproxy;
  configFile = config.age.secrets.naiveConfig.path;

in
{
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
}
