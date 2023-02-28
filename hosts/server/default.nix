_: {
  networking.hostName = "rxtx";

  imports = [
    ./hardware.nix

    ../../modules/basics
    ../../modules/services
    ../../modules/shell
  ];

  custom = {
    basics.ssh.enable = false;
    services = {
      caddy.enable = true;
      calibre-web.enable = true;
      firewall.enable = true;
      miniflux.enable = true;
      naive.enable = true;
      onedrive.enable = true;
      openssh.enable = true;
      vaultwarden.enable = true;
    };
    shell.proxy.enable = false;
  };
}
