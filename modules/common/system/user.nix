{ pkgs, user, ... }:

{
  users.users.${user} = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    password = "passwd";
  };
}
