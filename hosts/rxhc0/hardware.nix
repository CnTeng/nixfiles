{ modulesPath, ... }: {
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  hardware' = {
    persist.enable = true;
    systemd-boot.enable = true;
  };

  boot.initrd.kernelModules = [ "virtio_gpu" ];
  boot.kernelParams = [ "console=tty" ];

  zramSwap.enable = true;

  systemd.network = {
    enable = true;
    networks."40-enp1s0" = {
      name = "enp1s0";
      DHCP = "ipv4";
      address = [ "2a01:4f8:1c17:4986::1/64" ];
      routes = [{ routeConfig.Gateway = "fe80::1"; }];
    };
  };
}
