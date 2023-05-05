{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.alacritty;
  inherit (config.basics') colorScheme;
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
            size = 15;
          };

          # Copy from https://github.com/catppuccin/alacritty
          colors = {
            primary = {
              background = "#${colorScheme.base}";
              foreground = "#${colorScheme.text}";
              dim_foreground = "#${colorScheme.text}";
              bright_foreground = "#${colorScheme.text}";
            };

            cursor = {
              text = "#${colorScheme.base}";
              cursor = "#${colorScheme.rosewater}";
            };
            vi_mode_cursor = {
              text = "#${colorScheme.base}";
              cursor = "#${colorScheme.lavender}";
            };

            search = {
              matches = {
                foreground = "#${colorScheme.base}";
                background = "#${colorScheme.subtext0}";
              };
              focused_match = {
                foreground = "#${colorScheme.base}";
                background = "#${colorScheme.green}";
              };
              footer_bar = {
                foreground = "#${colorScheme.base}";
                background = "#${colorScheme.subtext0}";
              };
            };

            hints = {
              start = {
                foreground = "#${colorScheme.base}";
                background = "#${colorScheme.yellow}";
              };
              end = {
                foreground = "#${colorScheme.base}";
                background = "#${colorScheme.subtext0}";
              };
            };

            selection = {
              text = "#${colorScheme.base}";
              background = "#${colorScheme.rosewater}";
            };

            normal = {
              black = "#${colorScheme.surface1}";
              red = "#${colorScheme.red}";
              green = "#${colorScheme.green}";
              yellow = "#${colorScheme.yellow}";
              blue = "#${colorScheme.blue}";
              magenta = "#${colorScheme.pink}";
              cyan = "#${colorScheme.teal}";
              white = "#${colorScheme.subtext1}";
            };

            bright = {
              black = "#${colorScheme.surface2}";
              red = "#${colorScheme.red}";
              green = "#${colorScheme.green}";
              yellow = "#${colorScheme.yellow}";
              blue = "#${colorScheme.blue}";
              magenta = "#${colorScheme.pink}";
              cyan = "#${colorScheme.teal}";
              white = "#${colorScheme.subtext0}";
            };

            dim = {
              black = "#${colorScheme.surface1}";
              red = "#${colorScheme.red}";
              green = "#${colorScheme.green}";
              yellow = "#${colorScheme.yellow}";
              blue = "#${colorScheme.blue}";
              magenta = "#${colorScheme.pink}";
              cyan = "#${colorScheme.teal}";
              white = "#${colorScheme.subtext1}";
            };

            indexed_colors = [
              {
                index = 16;
                color = "#${colorScheme.peach}";
              }
              {
                index = 17;
                color = "#${colorScheme.rosewater}";
              }
            ];
          };
        };
      };
    };
  };
}
