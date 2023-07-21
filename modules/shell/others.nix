{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.shell'.others;
in {
  options.shell'.others.enable = mkEnableOption "others" // {default = true;};

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [unzipNLS gzip unrar wget fd usbutils];
    };
  };
}
