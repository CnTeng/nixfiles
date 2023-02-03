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
        wl-clipboard
        tree-sitter

        # Require for telescope
        ripgrep
        fd

        /* Lua */
        sumneko-lua-language-server # LSP
        stylua # Formatter

        /* C & C++ */
        clang-tools # LSP & Formatter

        /* Markdown */
        marksman # LSP

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
