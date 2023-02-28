{ config, lib, pkgs, user, ... }:

with lib;

let cfg = config.custom.programs.looking-glass;
in {
  options.custom.programs.looking-glass = {
    enable = mkEnableOption "looking-glass";
  };

  config = mkIf cfg.enable {
    # Enable kvmfr
    boot = {
      extraModulePackages = with pkgs;
        [ linuxKernel.packages.linux_latest.kvmfr ];

      kernelModules = [ "kvmfr" ];

      kernelParams = [ "kvmfr.static_size_mb=64" ];
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="kvmfr", OWNER="${user}", GROUP="kvm", MODE="0660"
    '';

    virtualisation.libvirtd.qemu.verbatimConfig = ''
      cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm",
        "/dev/kvmfr0"
      ]
    ''; # If enable nvidia passthrough need to add nvram

    # Set looking-glass to use ivshmen without kvmfr
    # systemd.tmpfiles.rules = [
    #   "f /dev/shm/looking-glass 0660 ${user} qemu-libvirtd -"
    # ];

    fonts.fonts = [ pkgs.dejavu_fonts ]; # Need for looking-glass

    home-manager.users.${user} = {
      programs.looking-glass-client = {
        enable = true;
        settings = {
          app.shmFile = "/dev/kvmfr0";
          win.showFPS = true;
          spice.enable = false;
        };
      };
    };
  };
}
