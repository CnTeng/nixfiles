{
  lib,
  config,
  data,
  ...
}:
let
  inherit (config.core') user hostName;

  authorizedKeys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMu1Lx0CAwI3cS7GAScUI65xAk597v4O6tx62uFj81sLAAAADnNzaDp5Yms1QG5peG9z ssh:ybk5@nixos"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDs0h1vSB/0h8qYkRqqfzCSD/hewOFuAgJAqLwUBGLY4AAAAD3NzaDp5Yms1Y0BuaXhvcw== ssh:ybk5c@nixos"
  ] ++ lib.optionals (data.hosts.${hostName}.type == "remote") [ data.github.deploy_key_pub ];
in
{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    hostKeys = [
      {
        bits = 4096;
        path = config.sops.secrets.ssh_host_rsa_key.path;
        type = "rsa";
      }
      {
        path = config.sops.secrets.ssh_host_ed25519_key.path;
        type = "ed25519";
      }
    ];
  };

  users.users = {
    ${user}.openssh.authorizedKeys.keys = authorizedKeys;
    root.openssh.authorizedKeys.keys = authorizedKeys;
  };

  sops.secrets.ssh_host_rsa_key = {
    key = "hosts/${hostName}/host_rsa_key";
    restartUnits = [ "sshd.service" ];
  };
  sops.secrets.ssh_host_ed25519_key = {
    key = "hosts/${hostName}/host_ed25519_key";
    restartUnits = [ "sshd.service" ];
  };
}
