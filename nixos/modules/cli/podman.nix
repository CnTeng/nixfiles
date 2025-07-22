{ config, lib, ... }:
let
  cfg = config.cli'.podman;
in
{
  options.cli'.podman.enable = lib.mkEnableOption "";

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
