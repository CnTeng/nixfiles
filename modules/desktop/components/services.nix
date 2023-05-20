{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop'.components.services;
in {
  options.desktop'.components.services.enable = mkEnableOption "Services";

  config = mkIf cfg.enable {
    services = {
      gnome = {
        # Fix warning 'The name org.a11y.Bus was not provided by any .service files'
        at-spi2-core.enable = true;
        gnome-keyring.enable = true;
      };

      upower.enable = true;
    };
  };
}
