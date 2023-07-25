{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.locker;
  inherit (config.desktop'.profiles) colorScheme;
in {
  options.desktop'.profiles.locker = {
    enable = mkEnableOption "locker component";
    package =
      mkPackageOption pkgs "locker" {default = ["swaylock-effects"];};
  };

  config = mkIf cfg.enable {
    # Ensure swaylock can verify the password
    security.pam.services.swaylock = {};

    home-manager.users.${user} = {
      programs.swaylock = {
        enable = true;
        package = cfg.package;
        settings = with colorScheme; {
          daemonize = true; # Detach from the controlling terminal after locking
          screenshots = true;
          ignore-empty-password = true;
          disable-caps-lock-text = true;

          font = "RobotoMono Nerd Font";
          font-size = 40;

          clock = true;
          indicator = true;
          indicator-idle-visible = true;
          indicator-radius = 120;
          indicator-caps-lock = true;
          line-uses-inside = true;

          effect-blur = "20x3";
          fade-in = 0.1;

          ring-color = "${surface0}";
          inside-wrong-color = "${red}";
          ring-wrong-color = "${red}";
          key-hl-color = "${green}";
          bs-hl-color = "${red}";
          ring-ver-color = "${peach}";
          inside-ver-color = "${peach}";
          inside-color = "${mantle}";
          text-color = "${lavender}";
          text-clear-color = "${mantle}";
          text-ver-color = "${mantle}";
          text-wrong-color = "${mantle}";
          text-caps-lock-color = "${lavender}";
          inside-clear-color = "${teal}";
          ring-clear-color = "${teal}";
          inside-caps-lock-color = "${peach}";
          ring-caps-lock-color = "${surface0}";
          separator-color = "${surface0}";
        };
      };
    };
  };
}
