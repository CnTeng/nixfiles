{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.profiles.locker;
  inherit (config.desktop'.profiles) palette;
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
        settings = with palette; {
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

          ring-color = "${surface0.hex}";
          inside-wrong-color = "${red.hex}";
          ring-wrong-color = "${red.hex}";
          key-hl-color = "${green.hex}";
          bs-hl-color = "${red.hex}";
          ring-ver-color = "${peach.hex}";
          inside-ver-color = "${peach.hex}";
          inside-color = "${mantle.hex}";
          text-color = "${lavender.hex}";
          text-clear-color = "${mantle.hex}";
          text-ver-color = "${mantle.hex}";
          text-wrong-color = "${mantle.hex}";
          text-caps-lock-color = "${lavender.hex}";
          inside-clear-color = "${teal.hex}";
          ring-clear-color = "${teal.hex}";
          inside-caps-lock-color = "${peach.hex}";
          ring-caps-lock-color = "${surface0.hex}";
          separator-color = "${surface0.hex}";
        };
      };
    };
  };
}
