{
  config,
  inputs,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.hardware'.persist;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.hardware'.persist.enable = mkEnableOption' { };

  config = mkIf cfg.enable {
    boot.tmp.useTmpfs = true;

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [ "/var/lib" ];
      files = [ "/etc/machine-id" ];
      users.${user}.directories = [
        "Projects"
        ".cache"
        ".local"
        ".config"
      ];
    };
  };
}
