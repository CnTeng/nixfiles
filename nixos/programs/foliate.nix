{
  config,
  lib,
  pkgs,
  sources,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.foliate;
in {
  options.programs'.foliate.enable = mkEnableOption "Foliate";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [pkgs.foliate];

      xdg.configFile."com.github.johnfactotum.Foliate/themes.json".source = "${sources.catppuccin-foliate.src}/themes.json";
    };
  };
}
