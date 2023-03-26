{ config, lib, user, ... }:

with lib;

let cfg = config.custom.programs.kitty;
in {
  options.custom.programs.kitty = { enable = mkEnableOption "kitty"; };

  config = mkIf cfg.enable {
    environment.variables = {
      TERMINAL = "kitty";
      GLFW_IM_MODULE = "ibus"; # Enable fcitx for kitty
    };

    home-manager.users.${user} = {
      programs.kitty = {
        enable = true;
        font = {
          name = "FiraCode Nerd Font";
          size = 15;
        };
        theme = "Catppuccin-Macchiato";
        settings = {
          term = "xterm-256color";
          tab_fade = "1 1 1";
          tab_title_template =
            "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{index}:{title}";
        };
        extraConfig = ''
          modify_font underline_position +3
          modify_font underline_thickness 150%
        '';
      };
    };
  };
}
