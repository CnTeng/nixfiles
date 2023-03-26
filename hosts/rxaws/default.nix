_: {
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
      firewall.enable = true;
      naive.enable = true;
      onedrive.enable = true;
      openssh.enable = true;
    };
    shell = {
      proxy.enable = false;
      neovim.withNixTreesitter = false;
    };
  };
}
