# IGVT-g and nvidia passthrough refer to
# https://wiki.archlinux.org/title/Intel_GVT-g
# https://nixos.wiki/wiki/IGVT-g
# https://lantian.pub
{ config, lib, pkgs, user, ... }:
with lib;

let
  cfg = config.custom.hardware.kvm;
  inherit (cfg) passthrough;
in {
  options.custom.hardware.kvm = {
    enable = mkEnableOption "kvm";
    passthrough = mapAttrs (_: v: mkEnableOption (mkDoc v)) {
      intel = "IGVT-g passthrough";
      nvidia = "nvidia passthrough";
    };
  };

  config = mkIf cfg.enable {
    assertions = mkIf passthrough.nvidia [{
      assertion = !config.custom.hardware.gpu.nvidia.enable;
      message = "nvidia-offload conflicts with nvidia passthrough";
    }];

    nix.settings.system-features = [ "kvm" ]; # Enable kvm support

    users.users.${user}.extraGroups = [ "libvirtd" "kvm" ];

    boot = mkIf (passthrough.intel or passthrough.nvidia) {
      kernelModules = [
        "kvm-intel"
        "vfio"
        "vfio_pci"
        "vfio_iommu_type1"
        "vfio_mdev"
        "vfio_virqfd"
      ]; # Enable kvm in kernel and add vfio kernel modules

      kernelParams = mkIf passthrough.intel [
        "intel_iommu=on"
        "kvm.ignore_msrs=1"
        "i915.enable_guc=2"
      ];

      extraModprobeConfig =
        mkIf passthrough.nvidia "options vfio-pci ids=10de:1f91";
    };

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = mkIf (passthrough.intel or passthrough.nvidia) {
          ovmf.enable = true;
          swtpm.enable = true;
          verbatimConfig = mkIf passthrough.nvidia ''
            nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
          '';
        };
      };

      kvmgt = mkIf passthrough.intel {
        enable = true;
        vgpus = {
          "i915-GVTg_V5_4" = {
            uuid = [ "79544a60-667d-11ed-a252-4bef3ca9611e" ];
          };
        };
      };
    };

    home-manager.users.${user} = {
      home.packages = with pkgs; [ virt-manager pciutils usbutils ];
    };
  };
}
