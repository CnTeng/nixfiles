{
  imports = [ ./hardware.nix ];

  accounts' = {
    gmail.enable = true;
    lkml.enable = true;
  };

  development'.neovim = {
    enable = true;
    withExtraPackages = true;
  };

  services'.trojan.enableClient = true;
}
