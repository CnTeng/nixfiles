{ config, user, ... }:

let
  homeDirectory = config.home-manager.users.${user}.home.homeDirectory;
in
{
  programs.ssh.startAgent = true;

  home-manager.users.${user} = {
    programs.ssh = {
      enable = true;
      matchBlocks.rxtx = {
        hostname = "43.134.194.35";
        port = 33;
        user = "yufei";
        forwardAgent = true;
        identityFile = [
          "${homeDirectory}/.ssh/id_ed25519_sk_rk_rxtx@NixOS"
        ];
      };
    };
  };
}
