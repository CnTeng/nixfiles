{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  accounts' = {
    gmail.enable = true;
    lkml.enable = true;
  };

  desktop' = {
    niri.enable = true;
    fonts.enable = true;
    input.enable = true;
    theme.enable = true;
    xdg.enable = true;
  };

  development' = {
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
    anki.enable = true;
    calibre.enable = true;
    chromium.enable = true;
    firefox.enable = true;
    ghostty.enable = true;
    kdeconnect.enable = true;
    kitty.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
    onedrive.enable = true;
    opencode.enable = true;
    spotify.enable = true;
    telegram.enable = true;
    yubikey.enable = true;
    zotero.enable = true;
  };

  services' = {
    fwupd.enable = true;
    restic.enable = true;
    tailscale.enable = true;
    trojan.enableClient = true;
  };
}
