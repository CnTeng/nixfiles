{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.gui'.kitty;
  inherit (pkgs.vimPlugins) smart-splits-nvim kitty-scrollback-nvim;
in
{
  options.gui'.kitty.enable = lib.mkEnableOption "kitty";

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

        "kitty/kitty_scrollback_nvim.py" = {
          source = "${kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py";
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
          "ctrl+enter" = "launch --location=split";
          "ctrl+q" = "close_window";
          "ctrl+w>q" = "close_window";

          "ctrl+j" = "neighboring_window down";
          "ctrl+k" = "neighboring_window up";
          "ctrl+h" = "neighboring_window left";
          "ctrl+l" = "neighboring_window right";

          "ctrl+w>j" = "move_window down";
          "ctrl+w>k" = "move_window up";
          "ctrl+w>h" = "move_window left";
          "ctrl+w>l" = "move_window right";

          "kitty_mod+h" = "kitten kitty_scrollback_nvim.py";
          "kitty_mod+g" = "kitten kitty_scrollback_nvim.py --config ksb_builtin_last_cmd_output";

          "ctrl+w>u" = "scroll_page_up";
          "ctrl+w>d" = "scroll_page_down";

          "ctrl+w>p" = "focus_visible_window";
          "kitty_mod+s" = "toggle_layout stack";

          "ctrl+w>o" = "layout_action rotate";
          "ctrl+o" = "layout_action rotate";

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
        };
        extraConfig = ''
          symbol_map U+4E00–U+9FFF Noto Sans Mono CJK SC

          modify_font underline_position +3
          modify_font underline_thickness 150%
          modify_font cell_height 120%

          map --new-mode resize ctrl+w>r

          map --mode resize j kitten relative_resize.py down  3
          map --mode resize k kitten relative_resize.py up    3
          map --mode resize h kitten relative_resize.py left  3
          map --mode resize l kitten relative_resize.py right 3

          map --mode resize esc pop_keyboard_mode
          map --mode resize ctrl+[ pop_keyboard_mode

          map --when-focus-on var:IS_NVIM ctrl+q

          map --when-focus-on var:IS_NVIM ctrl+j
          map --when-focus-on var:IS_NVIM ctrl+k
          map --when-focus-on var:IS_NVIM ctrl+h
          map --when-focus-on var:IS_NVIM ctrl+l

          map --when-focus-on var:IS_NVIM ctrl+w
        '';
      };
    };
  };
}
