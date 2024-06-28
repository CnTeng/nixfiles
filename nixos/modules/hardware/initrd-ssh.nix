{ config, lib, ... }:
let
  cfg = config.hardware'.initrd-ssh;
in
{
  options.hardware'.initrd-ssh.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    boot.initrd.network = {
      enable = true;
      udhcpc.enable = true;
    };

    boot.initrd.network.ssh = {
      enable = true;
      shell = "/bin/cryptsetup-askpass";
      hostKeys = [
        "/persist/etc/secrets/initrd/ssh_host_ed25519_key"
        "/persist/etc/secrets/initrd/ssh_host_rsa_key"
      ];
    };
  };
}
