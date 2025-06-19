{ user, ... }:
{
  home-manager.users.${user} = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      forwardAgent = true;
      addKeysToAgent = "yes";
      includes = [ "config.d/*.conf" ];
      matchBlocks."*" = {
        inherit user;
        identityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_ed25519_sk_rk_ybk5@nixos"
          "~/.ssh/id_ed25519_sk_rk_ybk5c@nixos"
        ];
      };
    };
  };

  preservation.preserveAt."/persist" = {
    users.${user}.directories = [ ".ssh" ];
  };
}
