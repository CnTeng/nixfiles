{ config, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  home.packages = with pkgs;[
    rofi-power-menu
  ];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs;[
      rofi-calc
      rofi-emoji
    ];
    font = "RobotoMono Nerd Font 13";
    location = "top";
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      modi = "run,drun,p:rofi-power-menu";
      icon-theme = "Papirus-Dark";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };

    theme = {
      "*" = {
        bg-col = mkLiteral "#24273a";
        bg-col-light = mkLiteral "#24273a";
        border-col = mkLiteral "#24273a";
        selected-col = mkLiteral "#24273a";
        blue = mkLiteral "#8aadf4";
        fg-col = mkLiteral "#cad3f5";
        fg-col2 = mkLiteral "#ed8796";
        grey = mkLiteral "#6e738d";
        width = mkLiteral "600";
      };

      "element-text, element-icon, mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "window" = {
        height = mkLiteral "360px";
        border = mkLiteral "3px";
        border-color = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "10px";
      };
      "mainbox" = {
        background-color = mkLiteral "@bg-col";
      };
      "inputbar" = {
        children = map mkLiteral [ "prompt" "entry" ];
        background-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "10px";
        padding = mkLiteral "2px";
      };

      "prompt" = {
        background-color = mkLiteral "@blue";
        padding = mkLiteral "6px";
        text-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "3px";
        margin = mkLiteral "20px 0px 0px 20px";
      };

      "textbox-prompt-colon" = {
        expand = false;
        str = ":";
      };

      "entry" = {
        padding = mkLiteral "6px";
        margin = mkLiteral "20px 0px 0px 10px";
        text-color = mkLiteral "@fg-col";
        background-color = mkLiteral "@bg-col";
      };

      "listview" = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "6px 0px 0px";
        margin = mkLiteral "10px 0px 0px 20px";
        columns = 2;
        lines = 5;
        background-color = mkLiteral "@bg-col";
      };

      "element" = {
        padding = mkLiteral "5px";
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@fg-col";
      };
      "element-icon" = {
        size = mkLiteral "48px";
      };

      "element selected" = {
        background-color = mkLiteral "@selected-col";
        text-color = mkLiteral "@fg-col2";
      };

      "mode-switcher" = {
        spacing = 0;
      };

      "button" = {
        padding = mkLiteral "10px";
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@grey";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
        border-radius = mkLiteral "10px";
      };

      "button selected" = {
        background-color = mkLiteral "@blue";
        text-color = "@fg-col";
      };
    };
  };
}
