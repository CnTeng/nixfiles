{ config, pkgs, ... }:

let
  # Catppuccin Macchiato
  # Copy from https://github.com/catppuccin/catppuccin
  base00 = "24273a"; # base
  base01 = "1e2030"; # mantle
  base02 = "363a4f"; # surface0
  base03 = "494d64"; # surface1
  base04 = "5b6078"; # surface2
  base05 = "cad3f5"; # text
  base06 = "f4dbd6"; # rosewater
  base07 = "b7bdf8"; # lavender
  base08 = "ed8796"; # red
  base09 = "f5a97f"; # peach
  base0A = "eed49f"; # yellow
  base0B = "a6da95"; # green
  base0C = "8bd5ca"; # teal
  base0D = "8aadf4"; # blue
  base0E = "c6a0f6"; # mauve
  base0F = "f0c6c6"; # flamingo

  powermenu = ./scripts/powermenu.sh;
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
      rofi-emoji
    ];
    font = "RobotoMono Nerd Font 15";
    location = "top";
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      steal-focus = true;
      disable-history = false;
      hide-scrollbar = true;
      sidebar-mode = true;
      modes = "drun,run,emoji,power:${powermenu}";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      drun-display-format = "{icon} {name}";
      display-drun = "  Apps ";
      display-run = " 異 Run ";
      display-emoji = "  Emoji ";
      display-power = " 襤 Power ";

      # Key binding
      kb-remove-char-back = "BackSpace,Shift+BackSpace"; # unbind ctrl+h
      kb-move-char-back = "Left,Control+h";

      kb-mode-complete = ""; # unbind ctrl+l
      kb-move-char-forward = "Right,Control+l";

      kb-accept-entry = "Control+m,Return,KP_Enter"; # unbind ctrl+j
      kb-element-next = "Tab,Control+j";

      kb-remove-to-eol = ""; # unbind ctrl+k
      kb-element-prev = "ISO_Left_Tab,Control+k";
    };

    theme = rec {
      "window" = {
        location = mkLiteral "north";
        anchor = mkLiteral "north";
        width = mkLiteral "600px";
        border = mkLiteral "0";
        background-color = mkLiteral "#${base00}f2";
        transparency = "real";
        border-radius = mkLiteral "10px";
        y-offset = mkLiteral "5px";
      };
      # mainbox -> window
      "mainbox" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "#${base05}";
      };

      # inputbar -> mainbox
      "inputbar" = {
        spacing = mkLiteral "10px";
        padding = mkLiteral "12px";
        border-radius = mkLiteral "10px 10px 0 0";
        background-color = mkLiteral "#${base0D}";
        text-color = mkLiteral "#${base00}";
        children = map mkLiteral [ "prompt" "entry" ];
      };
      # prompt -> inputbar
      "prompt" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      # entry -> inputbar
      "entry" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        vertical-align = mkLiteral "0.5";
      };

      # message -> mainbox
      "message" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      # textbox -> message
      "textbox" = {
        padding = mkLiteral "0 12px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };

      # listview -> mainbox
      "listview" = {
        margin = mkLiteral "12px 0";
        columns = 1;
        lines = 5;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        dynamic = mkLiteral "true";
      };
      # element -> listview
      "element" = {
        spacing = mkLiteral "10px";
        padding = mkLiteral "12px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "element-icon" = {
        size = mkLiteral "32px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "element-text" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };
      "element selected" = {
        background-color = mkLiteral "#${base02}";
        text-color = mkLiteral "inherit";
      };

      # mode-switcher -> mainbox
      "mode-switcher" = {
        border-radius = mkLiteral "0 0 10px 10px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      # button -> mode-switcher
      "button" = {
        padding = mkLiteral "12px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };
      "button selected" = {
        background-color = mkLiteral "#${base0D}";
        text-color = mkLiteral "#${base00}";
      };
    };
  };
}
