{pkgs, ...}: {
  imports = [./hardware.nix];

  basics'.system.stateVersion = "23.11";

  services'.openssh.enable = true;

  programs'.yubikey.enable = true;

  environment.systemPackages = with pkgs; [
    linuxPackages.usbip
    picocom
  ];
}
