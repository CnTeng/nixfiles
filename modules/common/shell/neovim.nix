{ lib, pkgs, user, ... }:

{
  # Dependency for Telescope man_pages
  documentation.man.generateCaches = true;

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
      # Dependency for neovim plugins
      ripgrep
      fd

      nixpkgs-fmt
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = true;
      extraPython3Packages = ps: with ps; [
        pip
      ];
    };

    xdg.configFile."nvim" = {
      source = ./nvim;
      recursive = true;
    };
  };
}
