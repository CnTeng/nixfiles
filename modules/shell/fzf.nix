# TODO: finsh fzf config
{ config, lib, user, ... }:
with lib;
let cfg = config.shell'.fzf;
in {
  options.shell'.fzf.enable = mkEnableOption "fzf" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = { programs.fzf = { enable = true; }; };
  };
}
