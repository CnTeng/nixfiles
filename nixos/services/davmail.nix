{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services'.davmail;
in {
  options.services'.davmail.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.davmail ];
    services.davmail = {
      enable = true;
      url = "https://outlook.office365.com/EWS/Exchange.asmx";
      config.davmail.mode = "O365";
    };
  };
}
