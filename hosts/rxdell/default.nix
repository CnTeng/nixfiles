{
  imports = [./hardware.nix ./disko.nix];

  basics' = {
    colors.flavour = "Mocha";
    system.stateVersion = "23.11";
  };

  desktop'.hyprland.enable = true;

  programs' = {
    alacritty.enable = true;
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

    foot.enable = true;
  };

  services' = {
    onedrive.enable = true;
    openssh.enable = true;
    dae.enable = true;
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
