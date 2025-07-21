palette:
{ config, lib, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Adwaita Mono:size=13";
        dpi-aware = "no";
        icon-theme = "Papirus-Dark";
        anchor = "top";
        y-margin = 8;
        lines = 5;
        width = 50;
        horizontal-pad = 24;
        cache = "${config.xdg.cacheHome}/fuzzel/cache";
      };
      colors = {
        background = palette.dialog_bg_color + "ff";
        text = palette.dialog_fg_color + "ff";
        prompt = palette.dialog_fg_color + "ff";
        input = palette.dialog_fg_color + "ff";
        match = palette.accent_color + "ff";
        selection = palette.selected_bg_color + "ff";
        selection-text = palette.selected_fg_color + "ff";
        selection-match = palette.accent_color + "ff";
      };
      border = {
        width = 0;
        radius = 16;
      };
    };
  };
}
