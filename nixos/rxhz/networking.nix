{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "8.8.8.8" ];

    defaultGateway = "172.31.1.1";

    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };

    dhcpcd.enable = false;

    usePredictableInterfaceNames = lib.mkForce false;

    interfaces = {
      eth0 = {
        ipv4.addresses = [{
          address = "78.47.24.36";
          prefixLength = 32;
        }];
        ipv6.addresses = [
          {
            address = "2a01:4f8:c17:dabe::1";
            prefixLength = 64;
          }
          {
            address = "fe80::9400:1ff:fefa:55f3";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [{
          address = "172.31.1.1";
          prefixLength = 32;
        }];
        ipv6.routes = [{
          address = "fe80::1";
          prefixLength = 128;
        }];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="96:00:01:fa:55:f3", NAME="eth0"
  '';
}
