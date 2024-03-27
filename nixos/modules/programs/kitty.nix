{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.kitty;
  inherit (pkgs.vimPlugins) smart-splits-nvim;
in
{
  options.programs'.kitty.enable = mkEnableOption "kitty";

  config = mkIf cfg.enable {
    environment.variables.TERMINAL = "kitty";

    home-manager.users.${user} = {
      xdg.configFile = {
        "kitty/pass_keys.py" = {
          source = "${smart-splits-nvim}/kitty/pass_keys.py";
          executable = true;
        };
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
        font = {
          name = "FiraCode Nerd Font";
          size = 12;
        };
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

          allow_remote_control yes
          listen_on unix:@mykitty

          map ctrl+j kitten pass_keys.py neighboring_window bottom ctrl+j
          map ctrl+k kitten pass_keys.py neighboring_window top    ctrl+k
          map ctrl+h kitten pass_keys.py neighboring_window left   ctrl+h
          map ctrl+l kitten pass_keys.py neighboring_window right  ctrl+l

          map alt+j kitten pass_keys.py relative_resize down  3 alt+j
          map alt+k kitten pass_keys.py relative_resize up    3 alt+k
          map alt+h kitten pass_keys.py relative_resize left  3 alt+h
          map alt+l kitten pass_keys.py relative_resize right 3 alt+l

          enabled_layouts splits:split_axis=horizontal
        '';
      };
    };
  };
}
