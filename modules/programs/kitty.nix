{ user, ... }:

{
  environment.variables = {
    TERMINAL = "kitty";
  };

  home-manager.users.${user} = {
    programs.kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 15;
      };
      theme = "Catppuccin-Macchiato";
    };

    # Solve ssh errors in kitty
    programs.zsh.shellAliases = {
      ssh = "kitty +kitten ssh";
    };
  };
}
