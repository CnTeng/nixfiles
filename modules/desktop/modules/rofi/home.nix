{ config, pkgs, ... }:

let
  colorScheme = import ../colorscheme.nix;

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

    theme = {
      "window" = {
        transparency = "real";
        location = mkLiteral "north";
        anchor = mkLiteral "north";
        width = mkLiteral "600px";
        y-offset = mkLiteral "5px";
        border = mkLiteral "0";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "#${colorScheme.base00}e6";
      };
      # mainbox -> window
      "mainbox" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "#${colorScheme.base05}";
      };

      # inputbar -> mainbox
      "inputbar" = {
        padding = mkLiteral "12px";
        spacing = mkLiteral "10px";
        border-radius = mkLiteral "10px 10px 0 0";
        background-color = mkLiteral "#${colorScheme.base0D}";
        text-color = mkLiteral "#${colorScheme.base00}";
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
        padding = mkLiteral "12px";
        spacing = mkLiteral "10px";
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
        border = mkLiteral "0 0 0 4px";
        border-color = mkLiteral "#${colorScheme.base0D}";
        background-color = mkLiteral "#${colorScheme.base03}";
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
        background-color = mkLiteral "#${colorScheme.base0D}";
        text-color = mkLiteral "#${colorScheme.base00}";
      };
    };
  };
}
