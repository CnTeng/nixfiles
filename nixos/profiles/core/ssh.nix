{ config, ... }:
{
  hm' = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      forwardAgent = true;
      addKeysToAgent = "yes";
      includes = [ "config.d/*.conf" ];
      matchBlocks."*" = {
        user = config.core'.userName;
        identityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_ed25519_sk_rk_ybk5@nixos"
          "~/.ssh/id_ed25519_sk_rk_ybk5c@nixos"
        ];
      };
    };
  };

  preservation'.user.directories = [ ".ssh" ];
}
