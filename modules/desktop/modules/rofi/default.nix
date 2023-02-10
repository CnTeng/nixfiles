{ user, ... }:

{
  home-manager.users.${user} = import ./home.nix;
}
