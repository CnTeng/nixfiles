{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services'.davmail;
in {
  options.services'.davmail.enable = mkEnableOption "Davmail";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.davmail ];
    services.davmail = {
      enable = true;
      url = "https://outlook.office365.com/EWS/Exchange.asmx";
      config = {
        davmail = {
          mode = "O365";
          caldavPort = 11080;
          imapPort = 11143;
          ldapPort = 11389;
          popPort = 11110;
          smtpPort = 11025;
        };
      };
    };
  };
}
