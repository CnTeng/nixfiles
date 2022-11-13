{ lib, pkgs, user, ... }:

{
  programs.nix-ld.enable = true;
  environment.variables.EDITOR = "nvim";

  home-manager.users.${user} = {
    home.sessionVariables = {
      NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
        stdenv.cc.cc
        openssl
        nss
        gcc
        # ...
      ];
      NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    };

    home.packages = [ pkgs.neovim ];

    xdg.configFile."nvim/lua".source = ./nvim/lua;
    xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  };
}
