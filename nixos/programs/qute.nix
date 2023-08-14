{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.qutebrowser;
in {
  options.programs'.qutebrowser.enable = mkEnableOption "qutebrowser";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.qutebrowser = {
        enable = true;
        searchEngines = {
          g = "https://www.google.com/search?hl=en&q={}";
        };
        extraConfig = ''
          import catppuccin

          config.load_autoconfig()

          catppuccin.setup(c, 'mocha', True)

        '';
      };
      xdg.configFile."qutebrowser/catppuccin".source = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "qutebrowser";
        rev = "main";
        sha256 = "sha256-lp7HWYuD4aUyX1nRipldEojZVIvQmsxjYATdyHWph0g=";
      };
    };
  };
}
