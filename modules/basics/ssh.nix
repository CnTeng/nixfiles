{ config, user, ... }:

{
  age.secrets.rxtxKey = {
    file = ../../secrets/ssh/rxtxKey.age;
    owner = "${user}";
    group = "users";
    mode = "600";
  };

  home-manager.users.${user} = {
    programs.ssh = {
      enable = true;
      matchBlocks."rxtx" = {
        hostname = "43.134.194.35";
        user = "yufei";
        port = 23;
        identityFile = [
          config.age.secrets.rxtxKey.path
        ];
      };
    };
  };
}
