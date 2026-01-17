{ config, lib, ... }:
let
  cfg = config.programs'.ghostty;
in
{
  options.programs'.ghostty.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    hm'.programs.ghostty = {
      enable = true;
      settings = {
        font-family = "FiraCode Nerd Font";
        font-size = 10;

        adjust-cell-height = "20%";
        adjust-underline-position = "20%";
        adjust-underline-thickness = "200%";
        adjust-cursor-height = "20%";

        theme = "dark:Adwaita Dark,light:Adwaita";

        gtk-single-instance = true;
      };
    };
  };
}
