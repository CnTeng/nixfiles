{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services'.protonmail-bridge;
in {
  options.services'.protonmail-bridge.enable = mkEnableOption "Protonmail Bridge";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.protonmail-bridge];

    systemd.user.services.protonmail-bridge = {
      description = "Protonmail Bridge";
      after = ["network.target"];
      path = [pkgs.gnome.gnome-keyring];
      serviceConfig = {
        Restart = "always";
        ExecStart = (getExe' pkgs.protonmail-bridge "protonmail-bridge") + " --noninteractive";
      };
      wantedBy = ["default.target"];
    };
  };
}
