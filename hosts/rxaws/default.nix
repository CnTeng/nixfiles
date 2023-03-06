{ user, ... }: {
  networking.hostName = "rxaws";

  imports = [
    ./hardware.nix

    ../../modules/basics
    ../../modules/services
    ../../modules/shell
  ];

  custom = {
    basics.ssh.enable = false;
    services = {
      firewall.enable = true;
      naive.enable = true;
      openssh.enable = true;
    };
    shell = {
      proxy.enable = false;
      neovim.withNixTreesitter = false;
    };
  };
}
