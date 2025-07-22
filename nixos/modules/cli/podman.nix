{
  config,
  lib,
  ...
}:
let
  cfg = config.cli'.podman;
  inherit (config.core') user;
in
{
  options.cli'.podman.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;

    preservation.preserveAt."/persist" = {
      directories = [
        "/var/lib/cni"
        "/var/lib/containers"
      ];
      users.${user}.directories = [ ".local/share/containers" ];
    };
  };
}
