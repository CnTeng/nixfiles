{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware'.power;
in {
  options.hardware'.power = {
    enable = mkEnableOption "power manager";
    freqGovernor = mkOption {
      type = with types; nullOr str;
      default = null;
      description = mdDoc ''
        One of "ondemand", "powersave", "performance"
      '';
    };
  };

  config = mkIf cfg.enable {
    services = {
      tlp.enable = true;
      thermald.enable = true;
    };
  };
}
