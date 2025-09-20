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

  development' = {
    clion.enable = true;
    flutter.enable = true;
    go.enable = true;
    neovim = {
      enable = true;
      withExtraPackages = true;
    };
    npm.enable = true;
    podman.enable = true;
    qemu.enable = true;
    sources.enable = true;
    tools.enable = true;
    wireshark.enable = true;
  };

  programs' = {
    aichat.enable = true;
    anki.enable = true;
    calibre.enable = true;
    chromium.enable = true;
    firefox.enable = true;
    ghostty.enable = true;
    kdeconnect.enable = true;
    kitty.enable = true;
    megasync.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
    office.enable = true;
    spotify.enable = true;
    telegram.enable = true;
    thunderbird.enable = true;
    todoist.enable = true;
    yubikey.enable = true;
    zotero.enable = true;
  };

  services' = {
    restic.enable = true;
    tailscale.enable = true;
    trojan.enableClient = true;
  };
}
