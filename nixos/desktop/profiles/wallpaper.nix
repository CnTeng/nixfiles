{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.desktop'.profiles.wallpaper;
in {
  options.desktop'.profiles.wallpaper = {
    enable = mkEnableOption "wallpaper profile";
    image = mkOption { type = with types; nullOr path; };
  };

  config = mkIf cfg.enable {
    desktop'.profiles.wallpaper.image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/l8/wallhaven-l8dgv2.jpg";
      sha256 = "sha256-dHTiXhzyju9yPVCixe7VMOG9T9FyQG/Hm79zhe0P4wk=";
    };

    home-manager.users.${user} = {
      xdg.configFile."hypr/hyprpaper.conf".text = ''
        preload = ${cfg.image}
        wallpaper = , ${cfg.image}
      '';

      systemd.user.services.hyprpaper = {
        Unit = {
          Description = "Hyprland wallpaper daemon";
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = getExe pkgs.hyprpaper;
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
