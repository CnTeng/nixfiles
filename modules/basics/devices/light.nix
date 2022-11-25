{ user, ... }:

{
  programs.light.enable = true;

  users.users.${user}.extraGroups = [ "video" ];
}
