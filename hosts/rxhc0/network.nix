{
  networking = {
    useDHCP = false;
    interfaces.enp1s0 = {
      useDHCP = true;
      ipv6 = {
        addresses = [{
          address = "2a01:4f8:1c17:4986::1";
          prefixLength = 64;
        }];
        routes = [{
          address = "::";
          prefixLength = 0;
          via = "fe80::1";
        }];
      };
    };
  };
}
