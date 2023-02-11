{ pkgs, user, ... }:

{
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  home-manager.users.${user} = {
    # Set the qt theme by using kvantum
    home.packages = [ pkgs.libsForQt5.qtstyleplugin-kvantum ];

    # Set the theme of cursor for the whole system
    home.pointerCursor = {
      name = "Catppuccin-Macchiato-Dark-Cursors";
      package = pkgs.catppuccin-cursors.macchiatoDark;
      size = 32;
      gtk.enable = true;
      x11.enable = true;
    };

    # Set the gtk theme
    gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Macchiato-Standard-Blue-Dark";
        package = pkgs.catppuccin-gtk.override {
          variant = "macchiato";
          tweaks = [ "rimless" ];
        };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        name = "Roboto";
      };
    };
  };
}
