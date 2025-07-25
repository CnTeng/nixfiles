{
  config,
  modulesPath,
  data,
  ...
}:
let
  inherit (config.core') hostName;
in
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  hardware'.stateless.enable = true;

  boot.initrd.systemd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    useDHCP = false;
    useNetworkd = true;
    interfaces.enp1s0 = {
      useDHCP = true;
      ipv6.addresses = [
        {
          address = data.hosts.${hostName}.ipv6;
          prefixLength = 64;
        }
      ];
      ipv6.routes = [
        {
          address = "::";
          prefixLength = 0;
          via = "fe80::1";
        }
      ];
    };
  };
}
