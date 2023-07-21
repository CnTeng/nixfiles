{
  networking = {
    usePredictableInterfaceNames = false;
    dhcpcd.enable = false;

    nameservers = ["8.8.8.8"];

    defaultGateway = "172.31.1.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };

    interfaces.eth0 = {
      ipv4 = {
        addresses = [
          {
            address = "49.13.50.247";
            prefixLength = 32;
          }
        ];
        routes = [
          {
            address = "172.31.1.1";
            prefixLength = 32;
          }
        ];
      };
      ipv6 = {
        addresses = [
          {
            address = "2a01:4f8:1c17:4986::1";
            prefixLength = 64;
          }
          {
            address = "fe80::9400:2ff:fe4a:8d7a";
            prefixLength = 64;
          }
        ];
        routes = [
          {
            address = "fe80::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="96:00:02:4a:8d:7a", NAME="eth0"
  '';
}
