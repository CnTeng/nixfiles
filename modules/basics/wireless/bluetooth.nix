{ user, ... }:

{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  home-manager.users.${user} = {
    services.blueman-applet.enable = true;
  };
}
