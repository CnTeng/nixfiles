{ pkgs, user, ... }:

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
  security.pam.services.swaylock = { }; # Ensure swaylock can verify the password

  environment.systemPackages = with pkgs; [
    swaylock-effects
  ];

  home-manager.users.${user} = {
    programs.swaylock.settings = {
      daemonize = true; # Detach from the controlling terminal after locking
      screenshots = true;
      ignore-empty-password = true;
      disable-caps-lock-text = true;

      font = "RobotoMono Nerd Font";
      font-size = 30;

      clock = true;
      indicator = true;
      indicator-idle-visible = true;
      indicator-radius = 120;
      indicator-caps-lock = true;
      line-uses-inside = true;

      effect-blur = "20x3";
      fade-in = 0.1;

      ring-color = "#${base02}";
      inside-wrong-color = "#${base08}";
      ring-wrong-color = "#${base08}";
      key-hl-color = "#${base0B}";
      bs-hl-color = "#${base08}";
      ring-ver-color = "#${base09}";
      inside-ver-color = "#${base09}";
      inside-color = "#${base01}";
      text-color = "#${base07}";
      text-clear-color = "#${base01}";
      text-ver-color = "#${base01}";
      text-wrong-color = "#${base01}";
      text-caps-lock-color = "#${base07}";
      inside-clear-color = "#${base0C}";
      ring-clear-color = "#${base0C}";
      inside-caps-lock-color = "#${base09}";
      ring-caps-lock-color = "#${base02}";
      separator-color = "#${base02}";
    };
  };
}
