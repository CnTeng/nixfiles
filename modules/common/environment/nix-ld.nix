{ lib, pkgs, user, ... }:

{
  programs.nix-ld.enable = true;

  home-manager.users.${user} = {
    home.sessionVariables = {
      NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
        stdenv.cc.cc
        openssl
        nss
        gcc
      ];
      NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    };

    home.packages = with pkgs; [
      # nix-alien
      nix-index
      nix-index-update
    ];
  };
}
