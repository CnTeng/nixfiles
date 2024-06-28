{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.programs'.kitty;
  inherit (pkgs.vimPlugins) smart-splits-nvim;
in
{
  options.programs'.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf cfg.enable {
    environment.variables.TERMINAL = "kitty";

    home-manager.users.${user} = {
      xdg.configFile = {
        "kitty/neighboring_window.py" = {
          source = "${smart-splits-nvim}/kitty/neighboring_window.py";
          executable = true;
        };
        "kitty/relative_resize.py" = {
          source = "${smart-splits-nvim}/kitty/relative_resize.py";
          executable = true;
        };
      };

      programs.kitty = {
        enable = true;
        font.name = "FiraCode Nerd Font";
        theme = "Adwaita dark";
        settings =
          let
            mkTabTitle =
              indicator:
              ''"${indicator} {fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{sup.index}{title}  "'';
          in
          {
            tab_bar_style = "separator";
            tab_separator = ''""'';
            tab_title_max_length = "18";
            tab_activity_symbol = ''"●"'';
            tab_title_template = mkTabTitle " ";
            active_tab_title_template = mkTabTitle "▎";

            enabled_layouts = "splits, stack";

            allow_remote_control = "yes";
            listen_on = "unix:@mykitty";
          };
        keybindings = {
          "kitty_mod+enter" = "launch --location=split";
          "kitty_mod+q" = "close_window";

          "kitty_mod+j" = "neighboring_window down";
          "kitty_mod+k" = "neighboring_window up";
          "kitty_mod+h" = "neighboring_window left";
          "kitty_mod+l" = "neighboring_window right";

          "ctrl+alt+j" = "move_window down";
          "ctrl+alt+k" = "move_window up";
          "ctrl+alt+h" = "move_window left";
          "ctrl+alt+l" = "move_window right";

          "kitty_mod+w" = "focus_visible_window";

          "ctrl+alt+s" = "toggle_layout stack";
          "ctrl+alt+v" = "layout_action rotate";

          "kitty_mod+1" = "goto_tab 1";
          "kitty_mod+2" = "goto_tab 2";
          "kitty_mod+3" = "goto_tab 3";
          "kitty_mod+4" = "goto_tab 4";
          "kitty_mod+5" = "goto_tab 5";
          "kitty_mod+6" = "goto_tab 6";
          "kitty_mod+7" = "goto_tab 7";
          "kitty_mod+8" = "goto_tab 8";
          "kitty_mod+9" = "goto_tab 9";
          "kitty_mod+0" = "goto_tab 10";
        };
        extraConfig = ''
          symbol_map U+4E00–U+9FFF Noto Sans Mono CJK SC

          modify_font underline_position +3
          modify_font underline_thickness 150%

          modify_font cell_height 120%

          map ctrl+j neighboring_window down
          map ctrl+k neighboring_window up
          map ctrl+h neighboring_window left
          map ctrl+l neighboring_window right

          map --when-focus-on var:IS_NVIM ctrl+j
          map --when-focus-on var:IS_NVIM ctrl+k
          map --when-focus-on var:IS_NVIM ctrl+h
          map --when-focus-on var:IS_NVIM ctrl+l

          map alt+j kitten relative_resize.py down  3
          map alt+k kitten relative_resize.py up    3
          map alt+h kitten relative_resize.py left  3
          map alt+l kitten relative_resize.py right 3

          map --when-focus-on var:IS_NVIM alt+j
          map --when-focus-on var:IS_NVIM alt+k
          map --when-focus-on var:IS_NVIM alt+h
          map --when-focus-on var:IS_NVIM alt+l
        '';
      };
    };
  };
}
