{ config, lib, user, ... }:
with lib;
let
  cfg = config.programs'.kitty;
  inherit (config.core'.colors) flavour;
in {
  options.programs'.kitty.enable = mkEnableOption "kitty";

  config = mkIf cfg.enable {
    environment.variables.TERMINAL = "kitty";

    home-manager.users.${user} = {
      programs.kitty = {
        enable = true;
        font = {
          name = "FiraCode Nerd Font";
          size = 12;
        };
        theme = "Catppuccin-${flavour}";
        settings = {
          # term = "xterm-256color";
          tab_fade = "1 1 1";
          tab_title_template =
            "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{index}:{title}";
        };
        extraConfig = ''
          symbol_map U+4E00–U+9FFF Sarasa Gothic SC
          modify_font underline_position +3
          modify_font underline_thickness 150%
        '';
      };
    };
  };
}
