# TODO: finsh fzf config
{ config, lib, user, ... }:

with lib;

let cfg = config.shell.module;
in {
  options.shell.module = {
    fzf = mkEnableOption "fzf" // { default = cfg.enable; };
  };

  config = mkIf cfg.fzf {
    home-manager.users.${user} = { programs.fzf = { enable = true; }; };
  };
}
