{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.utils'.nix-index;
in
{
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  options.utils'.nix-index.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    programs.command-not-found.enable = false;
    programs.nix-index-database.comma.enable = true;
  };
}
