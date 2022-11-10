{ pkgs, user, ... }:

{
  # Nvidia GPU passthrough
  # boot.kernelParams = [ "intel_iommu=on" ];
  #
  # boot.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" "vfio_virqfd" ];
  #
  # boot.extraModprobeConfig = "options vfio-pci ids=10de:1f91";

  # Enable kvm&libvirtd and set passthrough
  nix.settings.system-features = [ "kvm" ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      swtpm.enable = true;

      # Nvidia GPU passthrough
      # verbatimConfig = ''
      #   nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
      # '';
    };
  };
  users.users.${user}.extraGroups = [ "libvirtd" ];

  # Enable IGVT-g
  virtualisation.kvmgt = {
    enable = true;
    vgpus = {
      "i915-GVTg_V5_8" = {
        uuid = [ "ee2df328-52b3-11ed-8070-c75d156145fb" ];
      };
    };
  };

  # Set looking-glass to use ivshmen
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 ${user} qemu-libvirtd -"
  ];

  home-manager.users.${user} = {
    # Install virt-manager
    home.packages = with pkgs; [
      virt-manager
    ];

    # Set looking-glass
    programs.looking-glass-client = {
      enable = true;
      settings = {
        win = {
          fullScreen = true;
          showFPS = true;
        };
      };
    };
  };
}
