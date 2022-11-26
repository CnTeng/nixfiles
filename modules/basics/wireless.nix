{ user, ... }:

{
  # Network
  networking.networkmanager.enable = true;
  users.users.${user}.extraGroups = [ "networkmanager" ];

  # Bluetooth
  hardware.bluetooth.enable = true;
}
