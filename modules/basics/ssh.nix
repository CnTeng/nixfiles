{ config, user, ... }:

{
  home-manager.users.${user} = {
    programs.ssh = {
      enable = true;
      matchBlocks."rxtx" = {
        hostname = "ssh.snakepi.xyz";
        user = "yufei";
        port = 23;
        identityFile = [
          config.age.secrets.rxtxKey.path
        ];
      };
    };
  };

  age.secrets.rxtxKey = {
    file = ../../secrets/laptop/rxtxKey.age;
    owner = "${user}";
    group = "users";
    mode = "600";
  };
}
