{ config, pkgs, user, ... }:

{
  home-manager.users.${user} = {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          hostname = "ssh.github.com";
          user = "git";
          port = 443;
          identityFile = [
            config.age.secrets.githubAuthKey.path
          ];
        };
      };
    };

    programs.git = {
      enable = true;
      userName = "CnTeng";
      userEmail = "tengyufei@live.com";
    };

    home.packages = with pkgs;[
      gh
      pre-commit
      commitizen
      commitlint
    ];
  };

  age.secrets.githubAuthKey = {
    file = ../../../secrets/common/githubAuthKey.age;
    owner = "${user}";
    group = "users";
    mode = "600";
  };
}
