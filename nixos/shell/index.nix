{ inputs, config, lib, ... }:
with lib;
let cfg = config.shell'.nix-index;
in {
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  options.shell'.nix-index.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    programs.command-not-found.enable = false;
    programs.nix-index-database.comma.enable = true;
  };
}
