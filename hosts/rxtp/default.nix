{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  desktop'.cosmic.enable = true;

  cli' = {
    go.enable = true;
  };

  gui' = {
    android.enable = true;
    chrome.enable = true;
    firefox.enable = true;
    kdeconnect.enable = true;
    kitty.enable = true;
    mpv.enable = true;
    office.enable = true;
    others.enable = true;
    qtcreator.enable = true;
    sioyek.enable = true;
    thunderbird.enable = true;
    yubikey.enable = true;
  };

  services' = {
    mega.enable = true;
    restic.enable = true;
    postgresql.enable = true;
    tuic.client.enable = true;
  };
}
