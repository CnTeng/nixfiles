{ pkgs, user, ... }:

{

  # Network
  users.users.${user}.extraGroups = [ "networkmanager" ];
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
  };
  services.blueman.enable = true;

  home-manager.users.${user} = {
    services.blueman-applet.enable = true;
  };
}
