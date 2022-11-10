{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      gnumake
      cmake
      # gcc
      gcc12
      gdb
      # clang
      # clang_14
      # lldb
    ];
  };
}
