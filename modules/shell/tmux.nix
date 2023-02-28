# TODO: finsh tmux config
{ config, lib, ... }:

with lib;

let cfg = config.shell.module;
in {
  options.shell.module = {
    tmux = mkEnableOption "tmux" // { default = cfg.enable; };
  };

  config = mkIf cfg.tmux {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "screen-256color";
    };
  };
}
