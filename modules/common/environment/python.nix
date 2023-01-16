{ pkgs, user, ... }:

let
  packages = ps: with ps; [
    pip
  ];
in
{
  home-manager.users.${user} = {
    home.packages = [
      (pkgs.python3.withPackages packages)
    ];
  };
}
