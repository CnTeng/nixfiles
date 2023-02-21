{ pkgs, user, ... }:

let
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    p: with p; [
      vim
      lua
      json
      bash
      c
      cpp
      go
      nix
      python
      markdown
      markdown_inline
      org
    ]
  );

  TreesitterParsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = nvim-treesitter.dependencies;
  };
in
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

    xdg = {
      configFile = {
        "nvim/lua" = {
          source = ./lua;
          recursive = true;
        };
        "nvim/init.lua" = {
          source = ./init.lua;
        };
      };
      dataFile = {
        "nvim/lazy/nvim-treesitter" = {
          source = "${TreesitterParsers}";
          recursive = true;
        };
      };
    };
  };
}
