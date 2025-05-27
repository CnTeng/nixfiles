{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  desktop' = {
    niri.enable = true;
    fonts.enable = true;
    input.enable = true;
    theme.enable = true;
    xdg.enable = true;
  };

  cli'.neovim = {
    enable = true;
    withExtraPackages = true;
  };

  gui' = {
    chromium.enable = true;
    firefox.enable = true;
    kitty.enable = true;
  };

  services' = {
    restic.enable = true;
    tailscale.enable = true;
    trojan.enableClient = true;
  };
}
