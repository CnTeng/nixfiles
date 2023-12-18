{ config, lib, user, ... }:
with lib;
let
  cfg = config.shell'.gpg;

  inherit (config.hardware') persist;
in {
  options.shell'.gpg.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    programs.gnupg.agent.enable = true;

    environment.persistence."/persist" =
      mkIf persist.enable { users.${user}.directories = [ ".gnupg" ]; };
  };
}
