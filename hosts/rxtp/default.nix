{
  imports = [ ./hardware.nix ];

  system.stateVersion = "23.11";

  desktop'.sway.enable = true;

  programs' = {
    android.enable = true;
    chrome.enable = true;
    evince.enable = true;
    firefox.enable = true;
    kdeconnect.enable = true;

    kitty.enable = true;
    obs.enable = true;
    others.enable = true;
    qtcreator.enable = true;
    serial.enable = true;
    sioyek.enable = true;
    thunderbird.enable = true;
    vscode.enable = true;
    wezterm.enable = true;
    wps.enable = true;
    yubikey.enable = true;
    nautilus.enable = true;
  };

  services' = {
    restic.enable = true;
    tuic.client.enable = true;
  };
}
