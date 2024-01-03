{ config, modulesPath, ... }: {
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  hardware'.persist.enable = true;

  boot.initrd.kernelModules = [ "virtio_gpu" ];
  boot.kernelParams = [ "console=tty" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sops.secrets.rxhc0-ipv6 = {
    key = "outputs/hosts/value/rxhc0/ipv6";
    sopsFile = config.sops-file.infra;
  };

  sops.templates.enp1s0 = {
    content = ''
      [Match]
      Name=enp1s0

      [Network]
      DHCP=ipv4
      Address=${config.sops.placeholder.rxhc0-ipv6}

      [Route]
      Gateway=fe80::1
    '';
    owner = "systemd-network";
  };
  environment.etc."systemd/network/40-enp1s0.network".source =
    config.sops.templates.enp1s0.path;

  systemd.network.enable = true;
}
