{ user, ... }:

{
  home-manager.users.${user} = {
    programs.ssh = {
      enable = true;
      matchBlocks."rxtx" = {
        hostname = "ssh.snakepi.xyz";
        user = "yufei";
        port = 23;
      };
    };
  };
}
