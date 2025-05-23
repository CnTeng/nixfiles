{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  cli'.neovim = {
    enable = true;
    withExtraPackages = true;
  };

  desktop' = {
    niri.enable = true;
    fonts.enable = true;
    input.enable = true;
    theme.enable = true;
    xdg.enable = true;
  };

  gui' = {
    chromium.enable = true;
    firefox.enable = true;
    kitty.enable = true;
  };

  services' = {
    tailscale.enable = true;
    trojan.enableClient = true;
  };
}
