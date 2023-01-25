{ pkgs, user, ... }:

let
  colorScheme = import ./colorscheme.nix;
in
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [ jq ];

    programs.mako = {
      enable = true;
      backgroundColor = "#${colorScheme.base00}e6";
      textColor = "#${colorScheme.base05}";
      borderColor = "#${colorScheme.base0D}";
      progressColor = "over #${colorScheme.base02}";
      extraConfig = ''
        [urgency=high]
        border-color=#${colorScheme.base09}
      '';

      width = 400;
      height = 150;
      margin = "5";
      borderSize = 4;
      borderRadius = 10;
      maxIconSize = 96;
      defaultTimeout = 10000;
      font = "RobotoMono Nerd Font 14";
    };
  };
}
