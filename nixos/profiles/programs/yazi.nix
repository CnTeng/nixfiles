{ pkgs, ... }:
{
  hm'.programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    settings = {
      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };

    theme.status = {
      sep_left = {
        open = "";
        close = "";
      };
      sep_right = {
        open = "";
        close = "";
      };
    };

    initLua = /* lua */ ''
      require("git"):setup()
      require("starship"):setup()
    '';

    plugins = {
      git = pkgs.yaziPlugins.git;
      starship = pkgs.yaziPlugins.starship;
    };
  };
}
