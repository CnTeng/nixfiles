{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.desktop'.components.clipboard;
in {
  options.desktop'.components.clipboard.enable =
    mkEnableOption "clipboard component" // {default = true;};

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [pkgs.wl-clipboard];

      services.clipman.enable = true;
    };
  };
}
