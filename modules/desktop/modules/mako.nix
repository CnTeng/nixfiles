{ user, ... }:

let
  # Catppuccin Macchiato
  # Copy from https://github.com/catppuccin/catppuccin
  base00 = "24273a"; # base
  base01 = "1e2030"; # mantle
  base02 = "363a4f"; # surface0
  base03 = "494d64"; # surface1
  base04 = "5b6078"; # surface2
  base05 = "cad3f5"; # text
  base06 = "f4dbd6"; # rosewater
  base07 = "b7bdf8"; # lavender
  base08 = "ed8796"; # red
  base09 = "f5a97f"; # peach
  base0A = "eed49f"; # yellow
  base0B = "a6da95"; # green
  base0C = "8bd5ca"; # teal
  base0D = "8aadf4"; # blue
  base0E = "c6a0f6"; # mauve
  base0F = "f0c6c6"; # flamingo
in
{
  home-manager.users.${user} = {
    programs.mako = {
      enable = true;
      backgroundColor = "#${base00}f2";
      textColor = "#${base05}";
      borderColor = "#${base0D}";
      progressColor = "over #${base02}";
      extraConfig = ''
        [urgency=high]
        border-color=#${base09}
      '';

      width = 360;
      margin = "5";
      borderSize = 4;
      borderRadius = 10;
      defaultTimeout = 10000;
      font = "RobotoMono Nerd Font 13";
    };
  };
}
