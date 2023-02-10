{ pkgs, user, ... }:

let
  colorScheme = import ./colorscheme.nix;
in
{
  security.pam.services.swaylock = { }; # Ensure swaylock can verify the password

  home-manager.users.${user} = {
    home.packages = [ pkgs.swaylock-effects ];

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

      ring-color = "#${colorScheme.surface0}";
      inside-wrong-color = "#${colorScheme.red}";
      ring-wrong-color = "#${colorScheme.red}";
      key-hl-color = "#${colorScheme.green}";
      bs-hl-color = "#${colorScheme.red}";
      ring-ver-color = "#${colorScheme.peach}";
      inside-ver-color = "#${colorScheme.peach}";
      inside-color = "#${colorScheme.mantle}";
      text-color = "#${colorScheme.lavender}";
      text-clear-color = "#${colorScheme.mantle}";
      text-ver-color = "#${colorScheme.mantle}";
      text-wrong-color = "#${colorScheme.mantle}";
      text-caps-lock-color = "#${colorScheme.lavender}";
      inside-clear-color = "#${colorScheme.teal}";
      ring-clear-color = "#${colorScheme.teal}";
      inside-caps-lock-color = "#${colorScheme.peach}";
      ring-caps-lock-color = "#${colorScheme.surface0}";
      separator-color = "#${colorScheme.surface0}";
    };
  };
}
