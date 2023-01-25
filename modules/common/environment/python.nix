{ pkgs, user, ... }:

let
  packages = ps: with ps; [
    pip
    ipython
  ];
in
{
  home-manager.users.${user} = {
    home.packages = [
      (pkgs.python3.withPackages packages)
    ];
  };
}
