{lib, ...}: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = ["8.8.8.8"];

    defaultGateway = "172.31.1.1";

    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };

    dhcpcd.enable = false;

    usePredictableInterfaceNames = lib.mkForce false;

    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "162.55.166.175";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a01:4f8:c012:5223::1";
            prefixLength = 64;
          }
          {
            address = "fe80::9400:2ff:fe34:dd7a";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [
          {
            address = "172.31.1.1";
            prefixLength = 32;
          }
        ];
        ipv6.routes = [
          {
            address = "fe80::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="96:00:02:34:dd:7a", NAME="eth0"
  '';
}
