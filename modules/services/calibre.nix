{ config, lib, user, ... }:

with lib;

let
  cfg = config.custom.services.calibre-web;
  inherit (config.home-manager.users.${user}.home) homeDirectory;
in {
  options.custom.services.calibre-web.enable = mkEnableOption "Calibre-Web";

  config = mkIf cfg.enable {
    services.calibre-web = {
      enable = true;
      user = "${user}";
      group = "users";
      listen = {
        ip = "127.0.0.1";
        port = 7222;
      };
      openFirewall = true;
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
        calibreLibrary = "${homeDirectory}/OneDrive/Calibre";
      };
    };
  };
}
