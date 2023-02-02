{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      gcc
      gdb
      gnumake
      cmake
    ];
  };
}
