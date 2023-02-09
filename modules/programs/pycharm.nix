{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      jetbrains.pycharm-community
    ];
  };
}
