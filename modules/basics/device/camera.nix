{ user, ... }:

{
  programs.gphoto2.enable = true;

  users.users.${user}.extraGroups = [ "camera" ];
}
