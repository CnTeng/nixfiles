{
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.kdeconnect;
in {
  options.programs'.kdeconnect.enable = mkEnableOption "KDE connect";

  config = mkIf cfg.enable {
    programs.kdeconnect.enable = true;

    home-manager.users.${user} = {
      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
    };
  };
}
