{ config, user, ... }:

{
  networking.firewall.allowedTCPPorts = [ 587 3222 8222 ];

  services.vaultwarden = {
    enable = true;
    config = {
      # Domain settings
      DOMAIN = "https://pwd.snakepi.xyz";
      SIGNUPS_ALLOWED = true;

      # Rocket specific settings
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";


      # Enables websocket notifications
      WEBSOCKET_ENABLED = true;

      # Controls the WebSocket server address and port
      WEBSOCKET_ADDRESS = "127.0.0.1";
      WEBSOCKET_PORT = 3222;
    };
    environmentFile = config.age.secrets.vaultwardenEnv.path;
  };

  age.secrets.vaultwardenEnv = {
    file = ../../secrets/services/vaultwardenEnv.age;
    path = "/var/lib/vaultwarden.env";
    owner = "vaultwarden";
    group = "vaultwarden";
    mode = "644";
  };
}
