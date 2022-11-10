{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      jetbrains.jdk
      jetbrains.idea-community
    ];
  };
}
