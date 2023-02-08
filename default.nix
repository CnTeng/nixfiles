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

        /* Lua */
        sumneko-lua-language-server # LSP
        stylua # Formatter

        /* shell */
        nodePackages.bash-language-server # LSP
        shfmt # Formatter

        /* C & C++ */
        clang-tools # LSP & Formatter

        /* Nix */
        nil # LSP
        nixpkgs-fmt # Formatter

        /* Python */
        pyright # LSP
        black # Formatter

        /* Markdown */
        marksman # LSP
        nodePackages.prettier # Formatter
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
