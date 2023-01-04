{ user, ... }:

{
  networking.hostName = "rxdell";

  imports = [
    ./hardware.nix

    ../../modules/common

    ../../modules/basics

    ../../modules/desktop/hyprland

    # Programs
    ../../modules/programs/kitty.nix
    ../../modules/programs/alacritty.nix
    ../../modules/programs/onedrive.nix
    ../../modules/programs/firefox.nix
    ../../modules/programs/kvm.nix
    # ../../modules/programs/looking-glass.nix
    ../../modules/programs/yubikey.nix
    ../../modules/programs/vscode.nix
    ../../modules/programs/idea.nix
    ../../modules/programs/kdeconnect.nix
    ../../modules/programs/steam.nix
    ../../modules/programs/obs-studio.nix
    ../../modules/programs/others.nix

    ../../modules/programs/adb.nix
    ../../modules/programs/chromium.nix
  ];
}
