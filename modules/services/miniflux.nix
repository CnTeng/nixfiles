{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [ 1200 6222 ];

  virtualisation.oci-containers = {
    backend = "docker";

    # containers.freshrss = {
    #   image = "freshrss/freshrss";
    #   volumes = [
    #     "freshrss_data:/var/www/FreshRSS/data"
    #     "freshrss_extensions:/var/www/FreshRSS/extensions"
    #   ];
    #   ports = [ "6222:80" ];
    #   environment = {
    #     TZ = "Asia/Shanghai";
    #     CRON_MIN = "1,31";
    #   };
    # };

    containers.rsshub = {
      image = "diygod/rsshub";
      ports = [ "1200:1200" ];
    };
  };

  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "localhost:6222";
    };
  };
}

