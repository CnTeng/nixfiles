{
  pkgs,
  user,
  ...
}: {
  imports = [./hardware.nix];

  basics'.system.stateVersion = "23.11";

  services'.openssh.enable = true;

  programs'.yubikey.enable = true;

  services.udev = {
    enable = true;
    extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", MODE="0660", GROUP="plugdev"
    '';
  };

  users.groups.plugdev = {};
  users.users.${user}.extraGroups = ["plugdev"];

  environment.systemPackages = with pkgs; [
    linuxPackages.usbip
    picocom
    usbutils
  ];
}
