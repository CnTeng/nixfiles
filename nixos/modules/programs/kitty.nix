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
        settings = {
          # term = "xterm-256color";
          tab_fade = "1 1 1";
          tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{index}:{title}";
        };
        extraConfig = ''
          symbol_map U+4E00–U+9FFF Sarasa Gothic SC
          modify_font underline_position +3
          modify_font underline_thickness 150%
          modify_font cell_height 120%

          allow_remote_control yes
          listen_on unix:@mykitty

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

          enabled_layouts splits:split_axis=horizontal
        '';
      };
    };
  };
}
