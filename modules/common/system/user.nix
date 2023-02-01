{ pkgs, user, ... }:

{
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    password = "passwd";
  };
}
