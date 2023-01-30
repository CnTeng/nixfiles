{ user, ... }:

let
  colorScheme = import ../desktop/modules/colorscheme.nix;
in
{
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
            background = "#${colorScheme.base00}";
            foreground = "#${colorScheme.base05}";
            dim_foreground = "#${colorScheme.base05}";
            bright_foreground = "#${colorScheme.base05}";
          };

          cursor = {
            text = "#${colorScheme.base00}";
            cursor = "#${colorScheme.base06}";
          };
          vi_mode_cursor = {
            text = "#${colorScheme.base00}";
            cursor = "#${colorScheme.base07}";
          };

          search = {
            matches = {
              foreground = "#${colorScheme.base00}";
              background = "#A5ADCB";
            };
            focused_match = {
              foreground = "#${colorScheme.base00}";
              background = "#${colorScheme.base0B}";
            };
            footer_bar = {
              foreground = "#${colorScheme.base00}";
              background = "#A5ADCB";
            };
          };

          hints = {
            start = {
              foreground = "#${colorScheme.base00}";
              background = "#${colorScheme.base0A}";
            };
            end = {
              foreground = "#${colorScheme.base00}";
              background = "#A5ADCB";
            };
          };

          selection = {
            text = "#${colorScheme.base00}";
            background = "#${colorScheme.base06}";
          };

          normal = {
            black = "#${colorScheme.base03}";
            red = "#${colorScheme.base08}";
            green = "#${colorScheme.base0B}";
            yellow = "#${colorScheme.base0A}";
            blue = "#${colorScheme.base0D}";
            magenta = "#F5BDE6";
            cyan = "#${colorScheme.base0C}";
            white = "#B8C0E0";
          };

          bright = {
            black = "#${colorScheme.base04}";
            red = "#${colorScheme.base08}";
            green = "#${colorScheme.base0B}";
            yellow = "#${colorScheme.base0A}";
            blue = "#${colorScheme.base0D}";
            magenta = "#F5BDE6";
            cyan = "#${colorScheme.base0C}";
            white = "#A5ADCB";
          };

          dim = {
            black = "#${colorScheme.base03}";
            red = "#${colorScheme.base08}";
            green = "#${colorScheme.base0B}";
            yellow = "#${colorScheme.base0A}";
            blue = "#${colorScheme.base0D}";
            magenta = "#F5BDE6";
            cyan = "#${colorScheme.base0C}";
            white = "#B8C0E0";
          };

          indexed_colors = [
            { index = 16; color = "#${colorScheme.base09}"; }
            { index = 17; color = "#${colorScheme.base06}"; }
          ];
        };
      };
    };
  };
}
