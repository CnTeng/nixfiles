{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.cli'.podman;
in
{
  options.cli'.podman.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".local/share/containers" ];
    };
  };
}
