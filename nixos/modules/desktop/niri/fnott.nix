palette:
{ lib, ... }:
let
  removeHashTag = hex: lib.removePrefix "#" hex;
in
{
  services.fnott = {
    enable = true;
    settings = {
      main = {
        min-width = 500;
        max-width = 500;
        max-height = 200;
        edge-margin-vertical = 8;
        edge-margin-horizontal = 8;
        icon-theme = "Papirus-Dark";
        max-icon-size = 96;

        background = removeHashTag palette.dialog_bg_color + "ff";
        border-radius = 16;
        border-size = 0;

        title-font = "Adwaita Mono:size=10";
        title-format = "<b>%a%A</b>";
        summary-font = "Adwaita Mono:size=10";
        summary-format = "%s\n";
        body-font = "Adwaita Mono:size=10";

        max-timeout = 15;
        default-timeout = 15;
        idle-timeout = 15;
      };
      low = {
        background = removeHashTag palette.dialog_bg_color + "ff";
        title-color = removeHashTag palette.dialog_fg_color + "ff";
        summary-color = removeHashTag palette.dialog_fg_color + "ff";
        body-color = removeHashTag palette.dialog_fg_color + "ff";
      };
      critical = {
        background = removeHashTag palette.error_bg_color + "ff";
      };
    };
  };
}
