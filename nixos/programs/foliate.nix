{
  inputs,
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.programs'.foliate;
  inherit (inputs.catppuccin) foliateCat;
in {
  options.programs'.foliate.enable = mkEnableOption "Foliate";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [pkgs.foliate];

      xdg.configFile."com.github.johnfactotum.Foliate/themes.json".source = "${foliateCat}/themes.json";
    };
  };
}
