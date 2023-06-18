{ config, lib, sources, user, ... }:
with lib;
let
  cfg = config.programs'.alacritty;
  themeSrc = sources.catppuccin-alacritty.src;
in {
  options.programs'.alacritty.enable = mkEnableOption "Alacritty";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.alacritty = {
        enable = true;
        settings = {
          font = {
            normal.family = "FiraCode Nerd Font";
            bold.family = "FiraCode Nerd Font";
            italic.family = "FiraCode Nerd Font";
            bold_italic.family = "FiraCode Nerd Font";
            size = 12;
          };
          import = [ (themeSrc + /catppuccin-macchiato.yml) ];
        };
      };
    };
  };
}
