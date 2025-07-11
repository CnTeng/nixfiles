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

  cli' = {
    aichat.enable = true;
    flutter.enable = true;
    neovim = {
      enable = true;
      withExtraPackages = true;
    };
    npm.enable = true;
    podman.enable = true;
    todoist.enable = true;
  };

  gui' = {
    anki.enable = true;
    chromium.enable = true;
    firefox.enable = true;
    ghostty.enable = true;
    jetbrains.clion.enable = true;
    kdeconnect.enable = true;
    kitty.enable = true;
    megasync.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
    office.enable = true;
    others.enable = true;
    thunderbird.enable = true;
    wireshark.enable = true;
    yubikey.enable = true;
    zotero.enable = true;
  };

  services' = {
    restic.enable = true;
    tailscale.enable = true;
    trojan.enableClient = true;
  };
}
