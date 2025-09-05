{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.kitty.terminfo ];

  hm' = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      includes = [ "config.d/*.conf" ];
      matchBlocks."*" = {
        forwardAgent = true;
        addKeysToAgent = "yes";
        user = config.core'.userName;
        identityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_ed25519_sk_rk_ybk5@nixos"
          "~/.ssh/id_ed25519_sk_rk_ybk5c@nixos"
          "~/.ssh/id_ed25519_sk_rk_ybk5@git"
          "~/.ssh/id_ed25519_sk_rk_ybk5c@git"
        ];
      };
    };
  };

  preservation'.user.directories = [ ".ssh" ];
}
