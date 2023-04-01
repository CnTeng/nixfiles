{ config, lib, ... }:
with lib;
let cfg = config.basics'.locale;
in {
  options.basics'.locale = {
    enable = mkEnableOption "locale config" // { default = true; };
  };

  config = mkIf cfg.enable {
    time.timeZone = "Asia/Shanghai";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = { LC_CTYPE = "zh_CN.UTF-8"; };
    };
  };
}
