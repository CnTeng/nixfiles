{ pkgs, user, ... }:

{
  # Require for Telescope man_pages
  documentation.man.generateCaches = true;

  home-manager.users.${user} = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        # Require for nvim-treesitter 
        tree-sitter

        # Require for telescope.nvim
        ripgrep
        fd

        nodePackages.cspell # Spell checker
        nodePackages.prettier # Formatter

        /* Lua */
        sumneko-lua-language-server # LSP
        stylua # Formatter

        /* Markdown */
        marksman # LSP

        /* C & C++ */
        clang-tools # LSP & Formatter

        /* Nix */
        nil # LSP
        nixpkgs-fmt # Formatter

        /* Python */
        pyright # LSP
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
