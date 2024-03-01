{
  config,
  lib,
  user,
  ...
}:
with lib;
let
  cfg = config.core'.bash;
in
{
  options.core'.bash.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    programs.bash.blesh.enable = true;

    home-manager.users.${user} = {
      programs.bash.enable = true;
    };

    environment.persistence."/persist" = {
      users.${user} = {
        files = [ ".bash_history" ];
        directories = [ ".cache/blesh" ];
      };
    };
  };
}
