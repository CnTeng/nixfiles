{ ... }:

{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      # grub = {
      #   enable = true;
      #   version = 2;
      #   devices = [ "nodev" ];
      #   efiSupport = true;
      #   useOSProber = true;
      # };
      timeout = 1;
    };
  };
}
