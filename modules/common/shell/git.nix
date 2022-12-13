{ pkgs, user, ... }:

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
            "/home/${user}/.ssh/id_ed25519_sk_rk_auth@Github"
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
}
