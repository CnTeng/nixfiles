{ config, user, ... }:

{
  networking.firewall.allowedTCPPorts = [ 1200 6222 ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers.rsshub = {
      image = "diygod/rsshub";
      ports = [ "1200:1200" ];
      environment = {
        HOTLINK_TEMPLATE = "https://i3.wp.com/\${host}\${pathname}";
      };
    };
  };

  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "localhost:6222";
      BASE_URL = "https://rss.snakepi.xyz";
    };
    adminCredentialsFile = config.age.secrets.minifluxAdmin.path;
  };

  age.secrets.minifluxAdmin = {
    file = ../../secrets/server/minifluxAdmin.age;
    owner = "${user}";
    group = "users";
    mode = "644";
  };
}

