{ pkgs, agenix, user, ... }:

{
  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  environment.systemPackages = [
    agenix.defaultPackage.x86_64-linux
  ];
  age = {
    identityPaths = [
      "/home/${user}/OneDrive/Backups/Agenix/agenix_ed25519"
    ];
    secrets = {
      rxtx_hostname = {
        file = ../../../secrets/rxtx_hostname.age;
        owner = "${user}";
        group = "users";
        mode = "777";
      };
      rxtx_ed25519 = {
        file = ../../../secrets/rxtx_ed25519.age;
        owner = "${user}";
        group = "users";
        mode = "600";
      };
      github_auth_ed25519 = {
        file = ../../../secrets/github_auth_ed25519.age;
        owner = "${user}";
        group = "users";
        mode = "600";
      };
      "vaultwarden.env" = {
        file = ../../../secrets/vaultwarden.env.age;
        path = "/var/lib/vaultwarden.env";
        owner = "vaultwarden";
        group = "vaultwarden";
        mode = "777";
      };
      Caddyfile = {
        file = ../../../secrets/Caddyfile.age;
        owner = "${user}";
        group = "users";
        mode = "444";
      };
      naiveconfig = {
        file = ../../../secrets/naiveconfig.age;
        owner = "${user}";
        group = "users";
        mode = "444";
      };
    };
  };
}
