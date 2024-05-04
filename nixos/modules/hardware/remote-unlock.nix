{ config, lib, ... }:
let
  cfg = config.hardware'.remote-unlock;
in
{
  options.hardware'.remote-unlock.enable = lib.mkEnableOption' { };

  config = lib.mkIf cfg.enable {
    boot.initrd.network = {
      enable = true;
      udhcpc.enable = true;
    };

    boot.initrd.network.ssh = {
      enable = true;
      port = 2222;
      shell = "/bin/cryptsetup-askpass";
      hostKeys = [ "/persist/etc/secrets/initrd/ssh_host_ed25519_key" ];
    };

    environment.persistence."/persist" = {
      files = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
    };
  };
}
