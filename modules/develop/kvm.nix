{ pkgs, user, ... }:

{
  # Enable looking-glass
  # imports = [ ./looking-glass.nix ];

  # IGVT-g $ nvidia passthrough refer to 
  # https://wiki.archlinux.org/title/Intel_GVT-g
  # https://nixos.wiki/wiki/IGVT-g
  # https://lantian.pub

  # Enable kvm support in nix
  nix.settings.system-features = [ "kvm" ];

  # Enable kvm in kernel and add vfio kernel modules 
  boot.kernelModules = [
    "kvm-intel"
    "vfio"
    "vfio_pci"
    "vfio_iommu_type1"
    "vfio_mdev"
    "vfio_virqfd"
  ];

  # About IGVT-g
  boot.kernelParams = [
    "intel_iommu=on"
    "kvm.ignore_msrs=1"
    "i915.enable_guc=2"
  ];

  users.users.${user}.extraGroups = [ "libvirtd" "kvm" ];

  # Nvidia GPU passthrough
  # boot.extraModprobeConfig = "options vfio-pci ids=10de:1f91";

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      swtpm.enable = true;
      # verbatimConfig = ''
      #   nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
      # ''; # Nvidia GPU passthrough
    };
  };

  # Enable IGVT-g
  virtualisation.kvmgt = {
    enable = true;
    vgpus = {
      "i915-GVTg_V5_4" = {
        uuid = [ "79544a60-667d-11ed-a252-4bef3ca9611e" ];
      };
    };
  };

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      virt-manager
      pciutils
      usbutils
    ];
  };
}
