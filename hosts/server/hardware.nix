{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub.device = "/dev/vda";

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "xen_blkfront"
  ];
  boot.initrd.kernelModules = [ "nvme" ];

  boot.cleanTmpDir = true;

  # Enable BBR module
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
  };

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  zramSwap.enable = true;
}
