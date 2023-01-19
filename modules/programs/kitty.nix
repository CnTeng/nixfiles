{ user, ... }:

{
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
      extraConfig = ''
        modify_font underline_position +3
        modify_font underline_thickness 150%
      '';
    };

    # Solve ssh errors in kitty
    programs.zsh.shellAliases = {
      ssh = "kitty +kitten ssh";
    };
  };
}
