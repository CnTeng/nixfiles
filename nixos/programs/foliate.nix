{ config, lib, pkgs, themes, user, ... }:
with lib;
let
  cfg = config.programs'.foliate;
  inherit (themes) foliateTheme;
in {
  options.programs'.foliate.enable = mkEnableOption "Foliate";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.foliate ];

      xdg.configFile."com.github.johnfactotum.Foliate/themes.json".source =
        "${foliateTheme}/themes.json";
    };
  };
}
