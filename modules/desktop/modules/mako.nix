{ user, ... }:

{
  home-manager.users.${user} = {
    programs.mako = {
      enable = true;

      # Fork from https://github.com/catppuccin/mako/blob/main/src/macchiato
      backgroundColor = "#24273a";
      textColor = "#cad3f5";
      borderColor = "#8aadf4";
      progressColor = "over #363a4f";
      extraConfig = ''
        [urgency=high]
        border-color=#f5a97f
      '';

      width = 320;
      margin = "5";
      borderSize = 2;
      borderRadius = 10;
      defaultTimeout = 10000;
      font = "FiraCode Nerd Font 11";
    };
  };
}
