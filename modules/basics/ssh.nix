{ user, ... }:

{
  home-manager.users.${user} = {
    programs.ssh = {
      enable = true;
      matchBlocks.rxtx = {
        hostname = "ssh.snakepi.xyz";
        user = "yufei";
        port = 23;
        identityFile = [
          "/home/${user}/.ssh/id_ed25519_sk_rk_rxtx@NixOS"
        ];
      };
    };
  };
}
