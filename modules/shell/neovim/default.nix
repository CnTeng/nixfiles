{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.shell'.neovim;
in {
  options.shell'.neovim = {
    enable = mkEnableOption "Neovim" // { default = true; };
    withNixTreesitter = mkEnableOption "using of nix treesitter parsers" // {
      default = cfg.enable;
    };
  };

  config = mkIf cfg.enable {
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

          # Lua
          sumneko-lua-language-server # LSP
          stylua # Formatter

          # shell
          nodePackages.bash-language-server # LSP
          shfmt # Formatter

          # C & C++
          clang-tools # LSP & Formatter

          # Nix
          nil # LSP
          nixfmt # Formatter
          statix

          # Python
          pyright # LSP
          black # Formatter

          # Markdown
          marksman # LSP
          nodePackages.prettier # Formatter
        ];
      };

      xdg.configFile = {
        "nvim/lua" = {
          source = ./lua;
          recursive = true;
        };
        "nvim/init.lua" = { source = ./init.lua; };
      };

      xdg.dataFile."nvim/lazy/nvim-treesitter" = let
        treesitter = pkgs.vimPlugins.nvim-treesitter;
        nvim-treesitter = treesitter.withPlugins (p:
          with p; [
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
          ]);
        treesitterParsers = pkgs.symlinkJoin {
          name = "treesitter-parsers";
          paths = nvim-treesitter.dependencies;
        };
      in mkIf cfg.withNixTreesitter {
        source = "${treesitterParsers}";
        recursive = true;
      };
    };
  };
}
