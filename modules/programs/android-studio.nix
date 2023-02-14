{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      android-studio 
      kotlin
    ];
  };
}
