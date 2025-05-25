{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.gui'.foliate;
in
{
  options.gui'.foliate.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.foliate.enable = true;
    };

    environment.persistence."/persist" = {
      users.${user}.directories = [
        ".cache/com.github.johnfactotum.Foliate"
        ".local/share/com.github.johnfactotum.Foliate"
      ];
    };
  };
}
