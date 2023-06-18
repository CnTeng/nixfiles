{
  imports = [ ./hardware.nix ./disko.nix ];

  basics'.system.stateVersion = "23.11";

  desktop'.hyprland.enable = true;

  programs' = {
    alacritty.enable = true;
    android.enable = true;
    chrome.enable = true;
    evince.enable = true;
    firefox.enable = true;
    foliate.enable = true;
    kdeconnect.enable = true;
    kitty.enable = true;
    obs.enable = true;
    others.enable = true;
    spotify.enable = true;
    steam.enable = true;
    vscode.enable = true;
    yubikey.enable = true;
  };

  services'.onedrive.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
