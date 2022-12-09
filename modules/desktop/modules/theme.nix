{ pkgs, user, ... }:

{
  # Set the qt theme by using kvantum
  environment.systemPackages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
  ];
  qt5 = {
    enable = true;
    platformTheme = "qt5ct";
  };

  home-manager.users.${user} = {
    # Set the theme of cursor for the whole system
    home.pointerCursor = {
      name = "phinger-cursors";
      package = pkgs.phinger-cursors;
      size = 32;
      gtk.enable = true;
      x11.enable = true;
    };

    # Set the gtk theme
    gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Dark";
        package = pkgs.catppuccin-gtk;
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
