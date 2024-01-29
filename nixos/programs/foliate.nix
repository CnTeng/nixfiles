{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.programs'.foliate;
in
{
  options.programs'.foliate.enable = mkEnableOption "Foliate";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.foliate ];
    };
  };
}
