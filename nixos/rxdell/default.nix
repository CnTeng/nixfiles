{pkgs, ...}: {
  imports = [./hardware.nix ./disko.nix];

  basics'.system.stateVersion = "23.11";

  desktop'.hyprland.enable = true;

  programs' = {
    alacritty.enable = true;
    android.enable = true;
    chrome.enable = true;
    firefox.enable = true;
    foliate.enable = true;
    kdeconnect.enable = true;
    kitty.enable = true;
    obs.enable = true;
    others.enable = true;
    qutebrowser.enable = true;
    spotify.enable = true;
    steam.enable = true;
    vscode.enable = true;
    yubikey.enable = true;
  };

  services' = {
    onedrive.enable = true;
    openssh.enable = true;
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # services.udev.extraRules = ''
  #   ENV{ID_VENDOR_ID}=="067b", ENV{ID_MODEL_ID}=="2303", MODE:="666"
  # '';

  boot.kernelModules = ["ftdi_sio" "pl2303"];
  environment.systemPackages = with pkgs; [
    picocom
    minicom
    lrzsz
    gnome.gnome-terminal
  ];
}
