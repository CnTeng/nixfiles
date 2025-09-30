{ config, lib, ... }:
let
  cfg = config.services'.fwupd;
in
{
  options.services'.fwupd.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;

    preservation'.os.directories = [
      "/var/cache/fwupd"
      {
        directory = "/var/cache/fwupdmgr";
        user = "fwupd-refresh";
        group = "fwupd-refresh";
      }
      {
        directory = "/var/lib/fwupd";
        user = "fwupd-refresh";
        group = "fwupd-refresh";
      }
    ];
  };
}
