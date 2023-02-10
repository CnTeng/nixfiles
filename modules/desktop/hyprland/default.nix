{ pkgs, inputs, user, ... }:

{
  imports = [
    inputs.hyprland.nixosModules.default

    ../modules/theme.nix
    ../modules/waybar.nix
    ../modules/mako.nix
    ../modules/rofi
    ../modules/swayidle.nix
    ../modules/swaylock.nix
    ../modules/pcmanfm.nix
  ];

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs = {
    # If running from tty1 start hyprland
    bash.loginShellInit = ''
      [ "$(tty)" = "/dev/tty1" ] && exec Hyprland
    '';
    fish.loginShellInit = ''
      set TTY1 (tty)
      [ "$TTY1" = "/dev/tty1" ] && exec Hyprland
    '';
  };

  programs.hyprland = {
    enable = true;
    recommendedEnvironment = false;
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
    ] ++ [
      inputs.hyprpicker.packages.${system}.hyprpicker
    ];

    imports = [ ./home.nix ];
  };
}
