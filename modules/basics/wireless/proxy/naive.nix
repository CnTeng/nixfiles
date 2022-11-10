{ pkgs, config, ... }:

let
  naive = config.nur.repos.oluceps.naiveproxy;
  configFile = config.age.secrets.naiveconfig.path;

in
{
  environment.systemPackages = with config; [
    nur.repos.oluceps.naiveproxy
  ];


  systemd.services.naiveproxy = {
    description = "naiveproxy Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${naive}/bin/naive --config ${configFile}";
    };
  };
}
