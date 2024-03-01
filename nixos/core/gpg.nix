{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.core'.gpg;
in
{
  options.core'.gpg.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    programs.gnupg.agent.enable = true;

    environment.persistence."/persist" = {
      users.${user}.directories = [ ".gnupg" ];
    };
  };
}
