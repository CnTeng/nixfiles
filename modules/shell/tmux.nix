# TODO: finsh tmux config
{ config, lib, ... }:
with lib;
let cfg = config.shell'.tmux;
in {
  options.shell'.tmux.enable = mkEnableOption "tmux" // { default = true; };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "screen-256color";
    };
  };
}
