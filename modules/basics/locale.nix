{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.basics'.locale;
in {
  options.basics'.locale = {
    enable = mkEnableOption "locale config" // {default = true;};
  };

  config = mkIf cfg.enable {time.timeZone = "Asia/Shanghai";};
}
