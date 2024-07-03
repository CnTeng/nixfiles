{
  imports = [ ./hardware.nix ];

  desktop'.cosmic.enable = true;

  programs' = {
    android.enable = true;
    chrome.enable = true;
    firefox.enable = true;
    kdeconnect.enable = true;
    kitty.enable = true;
    others.enable = true;
    qtcreator.enable = true;
    serial.enable = true;
    sioyek.enable = true;
    thunderbird.enable = true;
    wps.enable = true;
    yubikey.enable = true;
  };

  services' = {
    restic.enable = true;
    postgresql.enable = true;
    syncthing.enable = true;
    tuic.client.enable = true;
  };

}
