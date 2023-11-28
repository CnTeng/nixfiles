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
      systemd.user.services.swaybg = {
        Unit = {
          Description = "Wayland wallpaper daemon";
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = getExe pkgs.swaybg + " -i ${cfg.image}" + " -m fill";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
