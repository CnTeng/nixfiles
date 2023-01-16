{ pkgs, user, ... }:

let
  packages = ps: with ps; [
    keyring
    gkeepapi
  ];
in

{
  home-manager.users.${user} = {
    home.packages = [
      # python3
      (pkgs.python3.withPackages packages)
    ];
  };
}
