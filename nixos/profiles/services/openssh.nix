{ config, user, ... }:
let
  authorizedKeys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMu1Lx0CAwI3cS7GAScUI65xAk597v4O6tx62uFj81sLAAAADnNzaDp5Yms1QG5peG9z ssh:ybk5@nixos"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDs0h1vSB/0h8qYkRqqfzCSD/hewOFuAgJAqLwUBGLY4AAAAD3NzaDp5Yms1Y0BuaXhvcw== ssh:ybk5c@nixos"
  ];
in
{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users = {
    ${user}.openssh.authorizedKeys.keys = authorizedKeys;
    root.openssh.authorizedKeys.keys = authorizedKeys;
  };

  services.openssh.authorizedKeysFiles = [ config.sops.secrets."ssh/nixos_deploy_key.pub".path ];

  sops.secrets."ssh/nixos_deploy_key.pub" = {
    key = "github/nixos_deploy_key_pub";
    mode = "0444";
  };

  environment.persistence."/persist" = {
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
