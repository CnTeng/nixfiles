{ config, lib, ... }:
let
  cfg = config.development'.podman;
in
{
  options.development'.podman.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;

    preservation' = {
      os.directories = [
        "/var/lib/cni"
        "/var/lib/containers"
      ];
      user.directories = [ ".local/share/containers" ];
    };
  };
}
