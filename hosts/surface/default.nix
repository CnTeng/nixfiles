{ lib, config, user, ... }:

{
  networking.hostName = "rxsf";

  imports = [
    ./hardware.nix

    ../../modules/common

    ../../modules/basics

    ../../modules/desktop/kde

    # Programs
    ../../modules/programs/kitty.nix
    ../../modules/programs/alacritty.nix
    ../../modules/programs/onedrive.nix
    ../../modules/programs/firefox.nix
    ../../modules/programs/vscode.nix
    ../../modules/programs/kdeconnect.nix
    ../../modules/programs/steam.nix
    ../../modules/programs/obs-studio.nix
    ../../modules/programs/others.nix
  ];
}
