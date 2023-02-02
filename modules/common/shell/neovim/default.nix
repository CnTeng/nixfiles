{ pkgs, user, ... }:

{
  # Require for Telescope man_pages
  documentation.man.generateCaches = true;

  home-manager.users.${user} = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = true;
      extraPython3Packages = ps: with ps; [
        pip
      ];
      extraPackages = with pkgs; [
        tree-sitter

        # Require for telescope
        ripgrep
        fd

        # C & C++
        clang-tools # LSP & Formatter

        # Markdown
        marksman # LSP

        # Nix
        nil # LSP
        nixpkgs-fmt # Formatter

        pyright

        # (python3.withPackages (ps: with ps; [
        #   pip
        #   ipython
        #   python-lsp-server
        # ]))
      ];
    };

    xdg.configFile = {
      "nvim/lua" = {
        source = ../neovim/lua;
        recursive = true;
      };
      "nvim/init.lua" = {
        source = ../neovim/init.lua;
      };
    };
  };
}
