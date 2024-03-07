{ config, modulesPath, ... }:
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  hardware' = {
    disko = {
      enable = true;
      device = "sda";
      bootSize = "1G";
      swapSize = "4G";
    };
    network.enable = true;
    optimise.enable = true;
    persist.enable = true;
  };

  boot.initrd.kernelModules = [ "virtio_gpu" ];
  boot.kernelParams = [ "console=tty" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sops.secrets.hcax-ipv6 = {
    key = "outputs/hosts/value/hcax/ipv6";
    sopsFile = config.sops-file.infra;
  };

  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  sops.templates.enp1s0 = {
    content = ''
      [Match]
      Name=enp1s0

      [Network]
      DHCP=ipv4
      Address=${config.sops.placeholder.hcax-ipv6}/64

      [Route]
      Gateway=fe80::1
    '';
    owner = "systemd-network";
  };
  environment.etc."systemd/network/40-enp1s0.network".source = config.sops.templates.enp1s0.path;

  boot.initrd.network.enable = true;
  boot.initrd.network.udhcpc.enable = true;

  systemd.network.enable = true;
}
