{ pkgs, user, ... }:

{
  # Require for Telescope man_pages
  documentation.man.generateCaches = true;

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Require for telescope
      ripgrep
      fd
      tree-sitter
      # Require for nix format
      nixpkgs-fmt
    ];

    home.sessionVariables = {
      # Require for marksman
      DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 1;
    };

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
