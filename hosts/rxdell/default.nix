{
  imports = [ ./disko.nix ./hardware.nix ];

  system.stateVersion = "23.11";

  desktop'.sway.enable = true;

  programs' = {
    adb.enable = true;
    chrome.enable = true;
    evince.enable = true;
    firefox.enable = true;
    foliate.enable = true;
    kdeconnect.enable = true;
    kitty.enable = true;
    obs.enable = true;
    others.enable = true;
    qtcreator.enable = true;
    serial.enable = true;
    steam.enable = true;
    vscode.enable = true;
    wps.enable = true;
    thunderbird.enable = true;
  };

  services' = {
    onedrive.enable = true;
    openssh.enable = true;
    restic.enable = true;
    tuic-client.enable = true;
  };
}
