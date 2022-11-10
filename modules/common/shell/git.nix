{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
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
