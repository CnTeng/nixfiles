{ config, lib, ... }:
with lib;
let cfg = config.core'.locale;
in {
  options.core'.locale.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    time.timeZone = "Asia/Shanghai";

    i18n.defaultLocale = "C.UTF-8";
  };
}
