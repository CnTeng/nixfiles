{ config, lib, pkgs, inputs, user, ... }:
with lib;
let cfg = config.desktop'.hyprland;
in {
  imports = [
    inputs.hyprland.nixosModules.default

    ../components
  ];

  options.desktop'.hyprland = {
    enable = mkEnableOption "hyprland";
    components.enable = mkEnableOption "desktop components" // {
      default = cfg.enable;
    };
  };

  config = mkIf cfg.enable {
    desktop'.components = mkIf cfg.components.enable {
      rofi.enable = true;
      applet.enable = true;
      fcitx.enable = true;
      fonts.enable = true;
      greetd.enable = true;
      mako.enable = true;
      pcmanfm.enable = true;
      swayidle.enable = true;
      swaylock.enable = true;
      theme.enable = true;
      waybar.enable = true;
    };


    programs.hyprland = {
      enable = true;
      nvidiaPatches = config.hardware'.gpu.nvidia.enable;
      recommendedEnvironment = false;
    };

    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    services.gnome = {
      # Fix warning 'The name org.a11y.Bus was not provided by any .service files'
      at-spi2-core.enable = true;
      gnome-keyring.enable = true;
    };

    # Customize the recommended environment
    environment.sessionVariables = {
      # GTK
      GDK_DPI_SCALE = "1.25";
      GDK_BACKEND = "wayland,x11";

      # QT
      QT_SCALE_FACTOR = "1.25";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # NIXOS_OZONE_WL = "1"; # Vscode need to run under xwayland to use fcitx5
      XDG_SESSION_DESKTOP = "Hyprland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };

    home-manager.users.${user} = {
      home.packages = with pkgs; [
        wl-clipboard
        slurp
        xdg-utils # For vscode and idea opening urls
        hyprpicker
      ];

      imports = [
        (import ./home.nix {
          inherit pkgs inputs user lib;
          inherit (config.home-manager.users.${user}.home) homeDirectory;
          inherit (config.programs.hyprland) nvidiaPatches;
          inherit (config.basics') colorScheme;
        })
      ];
    };
  };
}
