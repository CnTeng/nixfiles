{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.kitty;
  inherit (pkgs.vimPlugins) smart-splits-nvim;
in
{
  options.gui'.kitty.enable = lib.mkEnableOption' { };

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
        themeFile = "adwaita_dark";
        settings = {
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
          tab_title_max_length = "18";

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

          "ctrl+w>j" = "move_window down";
          "ctrl+w>k" = "move_window up";
          "ctrl+w>h" = "move_window left";
          "ctrl+w>l" = "move_window right";

          "kitty_mod+[" = "show_scrollback";

          "ctrl+w>u" = "scroll_page_up";
          "ctrl+w>d" = "scroll_page_down";

          "ctrl+w>p" = "focus_visible_window";
          "kitty_mod+s" = "toggle_layout stack";

          "ctrl+w>o" = "layout_action rotate";

          "ctrl+w>1" = "goto_tab 1";
          "ctrl+w>2" = "goto_tab 2";
          "ctrl+w>3" = "goto_tab 3";
          "ctrl+w>4" = "goto_tab 4";
          "ctrl+w>5" = "goto_tab 5";
          "ctrl+w>6" = "goto_tab 6";
          "ctrl+w>7" = "goto_tab 7";
          "ctrl+w>8" = "goto_tab 8";
          "ctrl+w>9" = "goto_tab 9";
          "ctrl+w>0" = "goto_tab 10";

          "alt+w" = "select_tab";

          "alt+j" = "kitten relative_resize.py down  3";
          "alt+k" = "kitten relative_resize.py up    3";
          "alt+h" = "kitten relative_resize.py left  3";
          "alt+l" = "kitten relative_resize.py right 3";
        };
        extraConfig = ''
          symbol_map U+4E00–U+9FFF Noto Sans Mono CJK SC

          modify_font underline_position +3
          modify_font underline_thickness 150%
          modify_font cell_height 120%

          map --when-focus-on var:IS_NVIM ctrl+w

          map --when-focus-on var:IS_NVIM alt+j
          map --when-focus-on var:IS_NVIM alt+k
          map --when-focus-on var:IS_NVIM alt+h
          map --when-focus-on var:IS_NVIM alt+l
        '';
      };
    };
  };
}
