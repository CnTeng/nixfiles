{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.basics'.locale;
in {
  options.basics'.locale.enable =
    mkEnableOption "locale config"
    // {
      default = true;
    };

  config = mkIf cfg.enable {
    time.timeZone = "Asia/Shanghai";

    i18n = {
      defaultLocale = "C.UTF-8";
      supportedLocales = [
        "C.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
        "zh_CN.GBK/GBK"
      ];
    };
  };
}
