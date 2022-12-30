{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      gnumake
      cmake
      gcc
      gdb
    ];
  };
}
