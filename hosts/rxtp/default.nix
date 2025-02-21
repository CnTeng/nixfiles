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
    flutter.enable = true;
    go.enable = true;
    podman.enable = true;
  };

  gui' = {
    android.enable = true;
    chrome.enable = true;
    firefox.enable = true;
    ghostty.enable = true;
    kdeconnect.enable = true;
    kitty.enable = true;
    mpv.enable = true;
    office.enable = true;
    others.enable = true;
    qtcreator.enable = true;
    sioyek.enable = true;
    thunderbird.enable = true;
    wireshark.enable = true;
    yubikey.enable = true;
    zed.enable = true;
  };

  services' = {
    mega.enable = true;
    restic.enable = true;
    postgresql.enable = true;
    trojan.enableClient = true;
  };
}
