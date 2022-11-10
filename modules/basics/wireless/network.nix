{ user, ... }:

{
  programs.nm-applet.enable = true;

  users.users.${user}.extraGroups = [ "networkmanager" ];
}
