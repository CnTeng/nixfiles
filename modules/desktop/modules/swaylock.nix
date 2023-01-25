{ pkgs, user, ... }:

let
  colorScheme = import ./colorscheme.nix;
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

      ring-color = "#${colorScheme.base02}";
      inside-wrong-color = "#${colorScheme.base08}";
      ring-wrong-color = "#${colorScheme.base08}";
      key-hl-color = "#${colorScheme.base0B}";
      bs-hl-color = "#${colorScheme.base08}";
      ring-ver-color = "#${colorScheme.base09}";
      inside-ver-color = "#${colorScheme.base09}";
      inside-color = "#${colorScheme.base01}";
      text-color = "#${colorScheme.base07}";
      text-clear-color = "#${colorScheme.base01}";
      text-ver-color = "#${colorScheme.base01}";
      text-wrong-color = "#${colorScheme.base01}";
      text-caps-lock-color = "#${colorScheme.base07}";
      inside-clear-color = "#${colorScheme.base0C}";
      ring-clear-color = "#${colorScheme.base0C}";
      inside-caps-lock-color = "#${colorScheme.base09}";
      ring-caps-lock-color = "#${colorScheme.base02}";
      separator-color = "#${colorScheme.base02}";
    };
  };
}
