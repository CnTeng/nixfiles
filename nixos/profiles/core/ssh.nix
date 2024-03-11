{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  mkHostConfig = name: host: port: user': {
    sops.secrets."${name}-ipv4" = {
      key = "${host}-ipv4";
      owner = user;
    };

    sops.templates."${name}-config" = {
      content = ''
        Host ${name}
          HostName ${config.sops.placeholder."${name}-ipv4"}'';
      owner = user;
    };

    home-manager.users.${user} = {
      programs.ssh = {
        includes = [ config.sops.templates."${name}-config".path ];
        matchBlocks.${name} = {
          inherit port;
          user = user';
          identityFile = [
            "~/.ssh/id_ed25519_sk_rk_ybk5@nixos"
            "~/.ssh/id_ed25519_sk_rk_ybk5c@nixos"
          ];
        };
      };
    };
  };

  mkHost =
    {
      name,
      luks ? false,
    }:
    mkMerge [
      (mkHostConfig name name 22 user)
      (optionalAttrs luks (mkHostConfig "${name}-luks" name 2222 "root"))
    ];
in
mkMerge [
  {
    home-manager.users.${user} = {
      services.ssh-agent.enable = true;

      programs.ssh = {
        enable = true;
        forwardAgent = true;
        addKeysToAgent = "yes";
      };
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".ssh" ];
    };
  }
  (mkHost {
    name = "hcax";
    luks = true;
  })
  (mkHost { name = "lssg"; })
]
