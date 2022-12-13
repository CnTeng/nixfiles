{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      ranger
      unzip
      gzip
      unrar
      wget
      nix-index
      neofetch
      rage
      age-plugin-yubikey
    ];
  };
}
