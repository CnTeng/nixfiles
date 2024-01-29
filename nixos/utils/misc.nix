{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.utils'.misc;
in
{
  options.utils'.misc.enable = mkEnableOption' { default = true; };

  config = mkIf cfg.enable {
    programs.direnv.enable = true;

    programs.bash.blesh.enable = true;

    home-manager.users.${user} = {
      programs.bash.enable = true;

      programs.zoxide.enable = true;

      home.packages = with pkgs; [
        wget
        tree
        neofetch
        scc
        gzip
        unrar
        unzipNLS
      ];
    };
  };
}
