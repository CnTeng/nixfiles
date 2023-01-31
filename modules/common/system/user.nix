{ pkgs, user, ... }:

{
  users.users.${user} = {
    isNormalUser = true;
    password = "passwd";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
}
