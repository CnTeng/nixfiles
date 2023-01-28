{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      unzip
      gzip
      unrar
      wget
      neofetch
    ];
  };
}
