{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.desktop'.profiles.services;
in
{
  options.desktop'.profiles.services.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    services.onedrive.enable = true;

    systemd.user.services.onedrive-launcher = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = mkForce [ "graphical-session.target" ];
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    services.gnome.at-spi2-core.enable = true;
    services.gnome.gnome-keyring.enable = true;

    services.gvfs.enable = true;

    # power
    services.upower.enable = true;
    services.tlp.enable = true;
    services.thermald.enable = true;

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".config/dconf"
        ".config/onedrive"
        ".local/share/keyrings"
        ".local/state/wireplumber"
        "OneDrive"
      ];
    };

    home-manager.users.${user} = {
      services.udiskie.enable = true;
      services.clipman.enable = true;

      services.playerctld.enable = true;
      services.swayosd.enable = true;
    };
  };
}
